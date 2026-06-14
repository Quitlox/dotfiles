# Claude Code - remote-control (server mode) session.
# 
# The Claude Code server mode works using an outbound connection; claude
# registers itself at the Antrhopic API and polls for work.
#
# Reuses the `opencode` user, group, home (/var/lib/opencode) and toolchain so both
# agents share one environment. See application-claude-setup.md for first-time auth.
{ config, lib, pkgs, ... }:
let
  # `claude remote-control` blocks on two prompts causing a restart due to no-TTY:
  #   - the one-time "Enable Remote Control? (y/n)" consent (`remoteDialogSeen`)
  #   - the workspace-trust dialog for the working directory
  #     (`projects."/var/lib/opencode".hasTrustDialogAccepted`)
  # Both live in ~/.claude.json. Pre-set them idempotently so the server starts
  # headless without any manual first-run step.
  prepare-claude-config = pkgs.writeShellScript "claude-prepare-config" ''
    set -eu
    cfg="/var/lib/opencode/.claude.json"
    [ -f "$cfg" ] || echo '{}' > "$cfg"
    check='.remoteDialogSeen == true and (.projects."/var/lib/opencode".hasTrustDialogAccepted == true)'
    if ${pkgs.jq}/bin/jq -e "$check" "$cfg" >/dev/null 2>&1; then
      exit 0
    fi
    tmp="$cfg.tmp"
    ${pkgs.jq}/bin/jq '
      .remoteDialogSeen = true
      | .projects."/var/lib/opencode".hasTrustDialogAccepted = true
    ' "$cfg" > "$tmp"
    ${pkgs.coreutils}/bin/install -m 600 "$tmp" "$cfg"
    rm -f "$tmp"
  '';
in
{
  # claude-code is unfree (proprietary); permit unfree for just this package.
  nixpkgs.config.allowUnfreePredicate =
    pkg: builtins.elem (lib.getName pkg) [ "claude-code" ];

  # Make `claude` available in the opencode user's interactive shell too.
  users.users.opencode.packages = [ pkgs.claude-code ];

  systemd.services.claude-serve = {
    description = "Claude Code remote-control server";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      User = "opencode";
      Group = "opencode";
      WorkingDirectory = "/var/lib/opencode";

      # Pre-accept the consent + workspace-trust prompts that would otherwise
      # block headless start (see prepare-claude-config above).
      ExecStartPre = "${prepare-claude-config}";

      # Server mode: serves remote sessions, no inbound listener.
      ExecStart = "${pkgs.claude-code}/bin/claude remote-control --name quitlox-homelab";

      Restart = "always";
      RestartSec = "10s";
    };

    environment = {
      # HOME is the one that matters: claude reads ~/.claude/.credentials.json,
      # ~/.claude.json, ~/.claude/settings.json, and the symlinked skills/CLAUDE.md.
      HOME = "/var/lib/opencode";
      XDG_CONFIG_HOME = "/var/lib/opencode/.config";
      XDG_DATA_HOME = "/var/lib/opencode/.local/share";

      GIT_SSH_COMMAND = "${pkgs.openssh}/bin/ssh";

      # remote-control renders an (optional) TUI; give it a sane terminal type
      # for the headless/no-TTY case.
      TERM = "xterm-256color";
    };

    path = [
      # Reuse the opencode user's toolchain. 
      "/etc/profiles/per-user/opencode/bin"
      "/run/wrappers/bin"
      "/run/current-system/sw/bin"
    ];
  };
}

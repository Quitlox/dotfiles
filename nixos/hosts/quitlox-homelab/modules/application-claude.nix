# Claude Code - remote-control (server mode) session.
#
# The Claude Code server mode works using an outbound connection; claude
# registers itself at the Anthropic API and polls for work.
#
# Runs as the shared `code` user/group with home /var/lib/code, the same
# identity and toolchain as the opencode agent, so both share one environment.
# See application-claude-setup.md for first-time auth.
{ config, lib, pkgs, ... }:
let
  # `claude remote-control` blocks on two prompts causing a restart due to no-TTY:
  #   - the one-time "Enable Remote Control? (y/n)" consent (`remoteDialogSeen`)
  #   - the workspace-trust dialog for the working directory
  #     (`projects."/var/lib/code".hasTrustDialogAccepted`)
  # Both live in ~/.claude.json. Pre-set them idempotently so the server starts
  # headless without any manual first-run step.
  prepare-claude-config = pkgs.writeShellScript "claude-prepare-config" ''
    set -eu
    cfg="/var/lib/code/.claude.json"
    [ -f "$cfg" ] || echo '{}' > "$cfg"
    check='.remoteDialogSeen == true and (.projects."/var/lib/code".hasTrustDialogAccepted == true)'
    if ${pkgs.jq}/bin/jq -e "$check" "$cfg" >/dev/null 2>&1; then
      exit 0
    fi
    tmp="$cfg.tmp"
    ${pkgs.jq}/bin/jq '
      .remoteDialogSeen = true
      | .projects."/var/lib/code".hasTrustDialogAccepted = true
    ' "$cfg" > "$tmp"
    ${pkgs.coreutils}/bin/install -m 600 "$tmp" "$cfg"
    rm -f "$tmp"
  '';
in
{
  # claude-code is unfree (proprietary); permit unfree for just this package.
  nixpkgs.config.allowUnfreePredicate =
    pkg: builtins.elem (lib.getName pkg) [ "claude-code" ];

  # Make `claude` available in the code user's interactive shell too.
  users.users.code.packages = [ pkgs.claude-code ];

  systemd.services.claude-serve = {
    description = "Claude Code remote-control server";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      User = "code";
      Group = "code";
      WorkingDirectory = "/var/lib/code";

      # Pre-accept the consent + workspace-trust prompts that would otherwise
      # block headless start (see prepare-claude-config above).
      ExecStartPre = "${prepare-claude-config}";

      # Server mode: serves remote sessions, no inbound listener.
      ExecStart = "${pkgs.claude-code}/bin/claude remote-control --name quitlox-homelab";

      Restart = "always";
      RestartSec = "10s";
    };

    environment = {
      HOME = "/var/lib/code";
      XDG_CONFIG_HOME = "/var/lib/code/.config";
      XDG_DATA_HOME = "/var/lib/code/.local/share";

      GIT_SSH_COMMAND = "${pkgs.openssh}/bin/ssh";

      # claude renders a TUI, so provide a default TERM
      TERM = "xterm-256color";
    };

    path = [
      "/etc/profiles/per-user/code"
      "/run/wrappers"
      "/run/current-system/sw"
    ];
  };
}

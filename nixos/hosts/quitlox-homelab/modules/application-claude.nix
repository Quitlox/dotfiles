# Claude Code - remote-control (server mode) session.
# 
# The Claude Code server mode works using an outbound connection; claude
# registers itself at the Antrhopic API and polls for work.
#
# Reuses the `opencode` user, group, home (/var/lib/opencode) and toolchain so both
# agents share one environment. See application-claude-setup.md for first-time auth.
{ config, lib, pkgs, ... }:
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

    # Reuse the opencode user's already-declared toolchain (git, ripgrep, fd, gh,
    # python, go, rust, etc.) via its per-user profile, instead of duplicating the
    # package list. /run/wrappers/bin + current-system keep the service self-contained.
    path = [
      "/etc/profiles/per-user/opencode/bin"
      "/run/wrappers/bin"
      "/run/current-system/sw/bin"
    ];
  };
}

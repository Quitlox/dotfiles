# Shared `code` user — used by opencode, claude, and code-server. 
# Home in /var/lib/code, projects in /var/lib/code/Workspace.
{ pkgs, ... }:
let
  codeUID = 1503;
  codeGID = 1503;
in
{
  ##############################################################################
  ### directories                                                            ###
  ##############################################################################

  systemd.tmpfiles.rules = [
    "d /var/lib/code                  0770 code code - -"
    "d /var/lib/code/Workspace        0770 code code - -"
    "d /var/lib/code/.config          0770 code code - -"
    "d /var/lib/code/.local           0770 code code - -"
    "d /var/lib/code/.local/share     0770 code code - -"
    "d /var/lib/code/.ssh             0770 code code - -"
    "d /var/lib/code/.cargo           0770 code code - -"
    "d /var/lib/code/.rustup          0770 code code - -"
  ];

  ##############################################################################
  ### user                                                                   ###
  ##############################################################################

  users.groups.code.gid = codeGID;
  users.groups.systemd-journal.members = [ "code" ];
  users.users.code = {
    uid = codeUID;
    home = "/var/lib/code";
    group = "code";
    isSystemUser = true;
    # Shell required for interactive auth flows (gh auth login, glab auth login, opencode auth login)
    shell = pkgs.bash;
    # Per-user toolchain → /etc/profiles/per-user/code, consumed by all services.
    packages = with pkgs; [
      # Core
      opencode
      # Shell
      bash
      openssh
      git
      gh
      glab
      fd
      ripgrep
      which
      curl
      jq
      wget
      inetutils # provides hostname
      util-linux # provides col
      binutils # provides strings
      docker # provides docker CLI
      gcc
      man-db
      man-pages
      nix
      # MCP
      procps # provides pgrep
      # Python
      python3
      uv
      pyright
      # Go
      go
      # Rust
      rustup
      rust-analyzer
    ];
  };
}

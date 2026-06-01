# OpenCode - Self-hosted AI coding agent server.
#
# Deployment
# - opencode.home.quitlox.dev
#
# First-time setup
# - See /var/lib/opencode/README.md for manual credential setup steps.
{ config, pkgs, ... }:
let
  domain = config.quitlox.traefik.domain;

  # Unprivileged user for the service
  opencodeUID = 1503;
  opencodeGID = 1503;

  # Packages needed by the opencode user and service
  opencodePackages = with pkgs; [
    # Core
    opencode
    gh
    glab
    git
    ripgrep
    fd
    # Python
    python3
    uv
    ruff
    pyright
    # Rust
    rustup
    rust-analyzer
  ];
in
{
  ##############################################################################
  ### directories                                                            ###
  ##############################################################################

  systemd.tmpfiles.rules = [
    "d /var/lib/opencode                          0700 opencode opencode - -"
    "d /var/lib/opencode/Workspace                0700 opencode opencode - -"
    "d /var/lib/opencode/.config                  0700 opencode opencode - -"
    "d /var/lib/opencode/.config/opencode         0700 opencode opencode - -"
    "d /var/lib/opencode/.local                   0700 opencode opencode - -"
    "d /var/lib/opencode/.local/share             0700 opencode opencode - -"
    "d /var/lib/opencode/.local/share/opencode    0700 opencode opencode - -"
    "d /var/lib/opencode/.ssh                     0700 opencode opencode - -"
    "d /var/lib/opencode/.cargo                   0700 opencode opencode - -"
    "d /var/lib/opencode/.rustup                  0700 opencode opencode - -"
  ];

  ##############################################################################
  ### user                                                                   ###
  ##############################################################################

  users.groups.opencode.gid = opencodeGID;
  users.users.opencode = {
    uid = opencodeUID;
    home = "/var/lib/opencode";
    group = "opencode";
    isSystemUser = true;
    # Shell required for interactive auth flows (gh auth login, glab auth login, opencode auth login)
    shell = pkgs.bash;
    # Per-user packages (available in interactive sessions as this user)
    packages = opencodePackages;
  };

  ##############################################################################
  ### service                                                                ###
  ##############################################################################

  systemd.services.opencode-serve = {
    description = "OpenCode headless server";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    # Password loaded from a manually-placed env file (chmod 600, owned by opencode).
    # Contains: OPENCODE_SERVER_PASSWORD=...
    # Optionally:  OPENCODE_SERVER_USERNAME=...
    # See /var/lib/opencode/README.md for setup instructions.
    serviceConfig = {
      User = "opencode";
      Group = "opencode";
      WorkingDirectory = "/var/lib/opencode/Workspace";
      EnvironmentFile = "/var/lib/opencode/server.env";

      ExecStart = "${pkgs.opencode}/bin/opencode serve --hostname 127.0.0.1 --port 4096";

      Restart = "always";
      RestartSec = "5s";

      # Light hardening — avoid overly restrictive sandboxing that would
      # break the agent's ability to run build tools and formatters.
      NoNewPrivileges = true;
    };

    environment = {
      # XDG base dirs pointing into the opencode user's home
      HOME = "/var/lib/opencode";
      XDG_CONFIG_HOME = "/var/lib/opencode/.config";
      XDG_DATA_HOME = "/var/lib/opencode/.local/share";

      # Rust toolchain dirs (rustup mutates these; keep them in the user home)
      RUSTUP_HOME = "/var/lib/opencode/.rustup";
      CARGO_HOME = "/var/lib/opencode/.cargo";
    };

    # Explicit PATH so the service is self-contained, independent of
    # profile activation order.
    path = opencodePackages;
  };

  ##############################################################################
  ### traefik                                                                ###
  ##############################################################################

  services.traefik.dynamicConfigOptions = {
    http.routers.opencode = {
      rule = "Host(`opencode.${domain}`)";
      entryPoints = [ "websecure" ];
      tls.certResolver = "letsencrypt";
      middlewares = [ "ip-internal@file" ];
      service = "opencode";
    };
    http.services.opencode = {
      loadBalancer.servers = [ { url = "http://127.0.0.1:4096"; } ];
    };
  };
}

# OpenCode - Self-hosted AI coding agent server.
#
# Deployment
# - opencode.home.quitlox.dev
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
    sudo
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
# Wrapper scripts that constrain exactly which privileged commands opencode
  # may run via sudo without a password.
  opencode-rebuild = pkgs.writeShellScriptBin "opencode-rebuild" ''
    exec /run/current-system/sw/bin/nixos-rebuild switch --flake /etc/nixos
  '';
  opencode-reboot = pkgs.writeShellScriptBin "opencode-reboot" ''
    exec /run/current-system/sw/bin/systemctl reboot
  '';
in
{
  ##############################################################################
  ### system-wide config                                                     ###
  ##############################################################################

  security.sudo.extraRules = [
    {
      users = [ "opencode" ];
      commands = [
        {
          command = "${opencode-rebuild}/bin/opencode-rebuild";
          options = [ "NOPASSWD" ];
        }
        {
          command = "${opencode-reboot}/bin/opencode-reboot";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  environment.systemPackages = [
    opencode-rebuild
    opencode-reboot
  ];

  # System-wide config at /etc/opencode/opencode.json
  # Takes precedence over ~/.config/opencode and can thus be used for machine
  # specific configuration.
  environment.etc."opencode/opencode.json".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/config.json";
    permission = {
      # The opencode user has limited access
      "external_directory" = "allow";
    };
  };

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
  ### secrets                                                               ###
  ##############################################################################

  sops.secrets."services/glance/opencode/user_name" = {
    owner = "opencode";
    group = "opencode";
  };
  sops.secrets."services/glance/opencode/user_pass" = {
    owner = "opencode";
    group = "opencode";
  };

  sops.templates."opencode.env" = {
    owner = "opencode";
    group = "opencode";
    content = ''
      OPENCODE_SERVER_USERNAME=${config.sops.placeholder."services/glance/opencode/user_name"}
      OPENCODE_SERVER_PASSWORD=${config.sops.placeholder."services/glance/opencode/user_pass"}
    '';
  };

  ##############################################################################
  ### service                                                                ###
  ##############################################################################

  systemd.services.opencode-serve = {
    description = "OpenCode headless server";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      User = "opencode";
      Group = "opencode";
      WorkingDirectory = "/var/lib/opencode/Workspace";
      EnvironmentFile = config.sops.templates."opencode.env".path;

      ExecStart = "${pkgs.opencode}/bin/opencode serve --hostname 0.0.0.0 --port 4096";

      Restart = "always";
      RestartSec = "5s";

      NoNewPrivileges = false;
    };

    environment = {
      # XDG base dirs pointing into the opencode user's home
      HOME = "/var/lib/opencode";
      XDG_CONFIG_HOME = "/var/lib/opencode/.config";
      XDG_DATA_HOME = "/var/lib/opencode/.local/share";

      # Rust toolchain dirs (rustup mutates these; keep them in the user home)
      RUSTUP_HOME = "/var/lib/opencode/.rustup";
      CARGO_HOME = "/var/lib/opencode/.cargo";
      
      # Configure SSH path
      GIT_SSH_COMMAND = "${pkgs.openssh}/bin/ssh";
    };

    # Explicit PATH so the service is self-contained, independent of
    # profile activation order.
    path = opencodePackages;
  };

  ##############################################################################
  ### firewall                                                               ###
  ##############################################################################

  # Allow Docker containers (e.g. Glance extension sidecar) to reach the
  # OpenCode API on the host. Protected by basic auth.
  networking.firewall.allowedTCPPorts = [ 4096 ];

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

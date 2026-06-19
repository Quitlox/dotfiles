# OpenCode - Self-hosted AI coding agent server.
#
# Deployment
# - opencode.home.quitlox.dev
{ config, pkgs, ... }:
let
  domain = config.quitlox.traefik.domain;

  # Privileged commands exposed to the code user
  code-rebuild = pkgs.writeShellScriptBin "code-rebuild" ''
    exec /run/current-system/sw/bin/nixos-rebuild switch --flake /etc/nixos
  '';
  code-reboot = pkgs.writeShellScriptBin "code-reboot" ''
    exec /run/current-system/sw/bin/systemctl reboot
  '';
in
{
  ##############################################################################
  ### system-wide config                                                     ###
  ##############################################################################

  security.sudo.extraRules = [
    {
      users = [ "code" ];
      commands = [
	# NOTE: sudo matches the string, so we require the runtime-path, not
	# the store-path.
        {
          command = "/run/current-system/sw/bin/code-rebuild";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/code-reboot";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  environment.systemPackages = [
    code-rebuild
    code-reboot
  ];

  # System-wide config at /etc/opencode/opencode.json
  # Takes precedence over ~/.config/opencode and can thus be used for machine
  # specific configuration.
  environment.etc."opencode/opencode.json".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/config.json";
    permission = {
      # The code user has limited access
      "external_directory" = "allow";
    };
  };

  ##############################################################################
  ### directories                                                            ###
  ##############################################################################

  # Base home dirs (.config, .local/share, etc.) come from user-code.nix; only the
  # opencode-specific leaves live here.
  systemd.tmpfiles.rules = [
    "d /var/lib/code/.config/opencode         0700 code code - -"
    "d /var/lib/code/.local/share/opencode    0700 code code - -"
  ];

  ##############################################################################
  ### secrets                                                               ###
  ##############################################################################

  sops.secrets."services/glance/opencode/user_name" = {
    owner = "code";
    group = "code";
  };
  sops.secrets."services/glance/opencode/user_pass" = {
    owner = "code";
    group = "code";
  };

  sops.templates."opencode.env" = {
    owner = "code";
    group = "code";
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
      User = "code";
      Group = "code";
      WorkingDirectory = "/var/lib/code/Workspace";
      EnvironmentFile = config.sops.templates."opencode.env".path;

      ExecStart = "${pkgs.opencode}/bin/opencode serve --hostname 0.0.0.0 --port 3002";

      Restart = "always";
      RestartSec = "5s";

      NoNewPrivileges = false;
    };

    environment = {
      # XDG base dirs pointing into the code user's home
      HOME = "/var/lib/code";
      XDG_CONFIG_HOME = "/var/lib/code/.config";
      XDG_DATA_HOME = "/var/lib/code/.local/share";

      # Rust toolchain dirs (rustup mutates these; keep them in the user home)
      RUSTUP_HOME = "/var/lib/code/.rustup";
      CARGO_HOME = "/var/lib/code/.cargo";

      # Configure SSH path
      GIT_SSH_COMMAND = "${pkgs.openssh}/bin/ssh";
    };

    path = [
      "/etc/profiles/per-user/code"
      "/run/wrappers"
      "/run/current-system/sw"
    ];
  };

  ##############################################################################
  ### firewall                                                               ###
  ##############################################################################

  # Allow Docker containers (e.g. Glance extension sidecar) to reach the
  # OpenCode API on the host. Protected by basic auth.
  networking.firewall.allowedTCPPorts = [ 3002 ];

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
      loadBalancer.servers = [ { url = "http://127.0.0.1:3002"; } ];
    };
  };
}

# code-server - Browser-based VS Code.
#
# Deployment
# - code.home.quitlox.dev
#
{ config, lib, ... }:
{
  ##############################################################################
  ### directories                                                            ###
  ##############################################################################
  systemd.tmpfiles.rules = [
    "d /var/lib/code/.config/code-server      0700 code code - -"
    "d /var/lib/code/.local/share/code-server 0700 code code - -"
  ];

  ##############################################################################
  ### secrets                                                                ###
  ##############################################################################
  sops.secrets."services/code-server/pass_hash" = {
    owner = "code";
    group = "code";
  };
  sops.templates."code-server.env" = {
    owner = "code";
    group = "code";
    content = ''
      HASHED_PASSWORD=${config.sops.placeholder."services/code-server/pass_hash"}
    '';
  };

  ##############################################################################
  ### service                                                                ###
  ##############################################################################
  services.code-server = {
    enable = true;
    user = "code";
    group = "code";
    host = "127.0.0.1";
    port = 3001;
    auth = "password";
    disableTelemetry = true;
    disableUpdateCheck = true;
    disableWorkspaceTrust = true;
    extraArguments = [ "/var/lib/code/Workspace" ];
  };

  systemd.services.code-server.environment.HASHED_PASSWORD = lib.mkForce null;
  systemd.services.code-server.serviceConfig.EnvironmentFile =
    config.sops.templates."code-server.env".path;

  systemd.services.code-server.path = [
    "/etc/profiles/per-user/code"
    "/run/wrappers"
    "/run/current-system/sw"
  ];

  ##############################################################################
  ### traefik                                                                ###
  ##############################################################################
  quitlox.traefik.expose-internal.code.port = 3001;
}

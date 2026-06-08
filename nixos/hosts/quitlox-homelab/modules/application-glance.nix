# Glance - Self-hosted dashboard
#
# Deployment
# - glance.home.quitlox.dev
{ config, lib, ... }:
let
  domain = config.quitlox.traefik.domain;

  # Unprivileged user for the container
  glanceUID = 1505;
  glanceGID = 1505;

  mkInstallCmd = destDir: name: _type:
    "install -m 664 -o ${toString glanceUID} -g ${toString glanceGID} ${./glance/${destDir}/${name}} /var/lib/glance/${destDir}/${name}";

  regularFiles = dir: lib.filterAttrs (_: type: type == "regular") (builtins.readDir dir);

  configInstallCmds = lib.mapAttrsToList (mkInstallCmd "config") (regularFiles ./glance/config);
  assetInstallCmds = lib.mapAttrsToList (mkInstallCmd "assets") (regularFiles ./glance/assets);
in
{
  # Unprivileged user for the container
  users.groups.glance.gid = glanceGID;
  users.users.glance = {
    uid = glanceUID;
    home = "/var/lib/glance";
    group = "glance";
    isSystemUser = true;
  };

  # Allow the opencode user to edit the glance configuration
  users.users.opencode.extraGroups = [ "glance" ];

  # Create directory structure and deploy config files from the dotfiles repo on
  # every activation (always overwrite)
  system.activationScripts.glance-config = {
    deps = [ "users" "groups" ];
    text = ''
      install -d -m 770 -o ${toString glanceUID} -g ${toString glanceGID} /var/lib/glance
      install -d -m 770 -o ${toString glanceUID} -g ${toString glanceGID} /var/lib/glance/config
      install -d -m 770 -o ${toString glanceUID} -g ${toString glanceGID} /var/lib/glance/assets
      ${lib.concatStringsSep "\n      " configInstallCmds}
      ${lib.concatStringsSep "\n      " assetInstallCmds}
    '';
  };

  # sops template for the env file with API keys
  sops.secrets."hetzner/project-id" = {
    owner = "glance";
    group = "glance";
  };
  sops.templates."glance.env" = {
    owner = "glance";
    group = "root";
    content = ''
      RADARR_APIKEY=${config.sops.placeholder."services/radarr/apikey"}
      SONARR_APIKEY=${config.sops.placeholder."services/sonarr/apikey"}
      PROWLARR_APIKEY=${config.sops.placeholder."services/prowlarr/apikey"}
      BAZARR_APIKEY=${config.sops.placeholder."services/bazarr/apikey"}
      HETZNER_CLOUD_APIKEY=${config.sops.placeholder."hetzner/cloud-apikey"}
      HETZNER_PROJECT_ID=${config.sops.placeholder."hetzner/project-id"}
      OPENCODE_USERNAME=${config.sops.placeholder."services/opencode/user_name"}
      OPENCODE_PASSWORD=${config.sops.placeholder."services/opencode/user_pass"}
    '';
  };

  virtualisation.arion.projects.glance.settings = {
    project.name = "glance";
    networks.proxy.name = "proxy";
    services.glance.service = {
      image = "glanceapp/glance";
      container_name = "glance";
      restart = "unless-stopped";
      user = "${toString glanceUID}:${toString glanceGID}";
      networks = [ "proxy" ];
      env_file = [ config.sops.templates."glance.env".path ];
      volumes = [
        "/var/lib/glance/config:/app/config"
        "/var/lib/glance/assets:/app/assets"
        "/etc/localtime:/etc/localtime:ro"
      ];
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.glance.rule" = "Host(`glance.${domain}`)";
        "traefik.http.routers.glance.middlewares" = "ip-internal@file";
        "traefik.http.routers.glance.service" = "glance";
        "traefik.http.services.glance.loadbalancer.server.port" = "8080";
      };
    };
  };
}

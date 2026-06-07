# Glance - Self-hosted dashboard
#
# Deployment
# - glance.home.quitlox.dev
{ config, ... }:
let
  domain = config.quitlox.traefik.domain;

  # Unprivileged user for the container
  glanceUID = 1505;
  glanceGID = 1505;
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
      install -m 664 -o ${toString glanceUID} -g ${toString glanceGID} ${./glance/config/glance.yml} /var/lib/glance/config/glance.yml
      install -m 664 -o ${toString glanceUID} -g ${toString glanceGID} ${./glance/config/home.yml}   /var/lib/glance/config/home.yml
      install -m 664 -o ${toString glanceUID} -g ${toString glanceGID} ${./glance/config/widget-media-status.yml} /var/lib/glance/config/widget-media-status.yml
      install -m 664 -o ${toString glanceUID} -g ${toString glanceGID} ${./glance/assets/user.css}   /var/lib/glance/assets/user.css
    '';
  };

  # sops template for the env file with API keys
  sops.templates."glance.env" = {
    owner = "glance";
    group = "root";
    content = ''
      RADARR_APIKEY=${config.sops.placeholder."services/radarr/apikey"}
      SONARR_APIKEY=${config.sops.placeholder."services/sonarr/apikey"}
      PROWLARR_APIKEY=${config.sops.placeholder."services/prowlarr/apikey"}
      BAZARR_APIKEY=${config.sops.placeholder."services/bazarr/apikey"}
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

# Glance - Self-hosted dashboard
#
# Deployment
# - glance.home.quitlox.dev
{ config, ... }:
let
  domain = config.quitlox.traefik.domain;

  # Unprivileged user for the container
  glanceUID = 1504;
  glanceGID = 1504;
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

  # Create directory structure
  systemd.tmpfiles.rules = [
    "d /var/lib/glance        0770 glance glance - -"
    "d /var/lib/glance/config 0770 glance glance - -"
    "d /var/lib/glance/assets 0770 glance glance - -"
  ];

  # Deploy config files from the dotfiles repo on every activation (always overwrite)
  system.activationScripts.glance-config = {
    deps = [ "users" "groups" ];
    text = ''
      install -m 664 -o ${toString glanceUID} -g ${toString glanceGID} ${./glance/config/glance.yml} /var/lib/glance/config/glance.yml
      install -m 664 -o ${toString glanceUID} -g ${toString glanceGID} ${./glance/config/home.yml}   /var/lib/glance/config/home.yml
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

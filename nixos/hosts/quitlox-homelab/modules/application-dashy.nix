# Dashy - The Ultimate Homepage for your Homelab
#
# Deployment
# - dashy.home.quitlox.dev
{ config, pkgs, ... }:
let
  domain = config.quitlox.traefik.domain;

  # Unpriviliged user for the container and the configuration file.
  dashyUID = 1501;
  dashyGID = 1501;

  # Default config, seeded once. Edits made afterwards are preserved.
  defaultConf = pkgs.writeText "dashy-conf.yml" ''
    pageInfo:
      title: HomeLab Dashboard
    sections: []
  '';
in
{
  systemd.tmpfiles.rules = [
    "d /var/lib/dashy/ 0700 dashy dashy - -"
    "C /var/lib/dashy/conf.yml 0644 dashy dashy - ${defaultConf}"
  ];

  # Unpriviliged user for the container and the configuration file.
  users.groups.dashy.gid = dashyGID;
  users.users.dashy = {
    uid = dashyUID;
    home = "/var/lib/dashy";
    group = "dashy";
    isSystemUser = true;
  };

  virtualisation.arion.projects.dashy.settings = {
    project.name = "dashy";
    networks.proxy.name = "proxy";
    services.dashy.service = {
      image = "lissy93/dashy";
      container_name = "dashy";
      restart = "unless-stopped";
      user = "${toString dashyUID}:${toString dashyGID}";
      networks = [ "proxy" ];
      environment = {
        TZ = "Europe/Amsterdam";
      };
      volumes = [
        "/var/lib/dashy:/app/user-data"
      ];
      healthcheck = {
        test = [
          "CMD"
          "node"
          "/app/services/healthcheck.js"
        ];
        interval = "1m30s";
        timeout = "10s";
        retries = 3;
        start_period = "30s";
      };
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.dashy.rule" = "Host(`dashy.${domain}`)";
        "traefik.http.routers.dashy.middlewares" = "ip-internal@file";
        "traefik.http.routers.dashy.service" = "dashy";
        "traefik.http.services.dashy.loadbalancer.server.port" = "8080";
      };
    };
  };
}

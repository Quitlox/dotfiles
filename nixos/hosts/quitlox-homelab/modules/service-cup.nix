# Cup
#
# Lightweight Docker container update checker with a JSON API.
# Used as a data source by Glance to show current vs. latest versions
# with update type classification (major/minor/patch/digest).
#
# --- Deployment ---
#
# Serves its API internally on port 8000. Glance consumes the API
# via Docker container DNS at http://cup:8000/api/v3/json.
#
# Optional web UI at: https://cup.home.quitlox.dev (internal only).
#
{ config, ... }:
let
  domain = config.quitlox.traefik.domain;

  cupUID = 1506;
  cupGID = 1506;
in
{
  users.groups.cup.gid = cupGID;
  users.users.cup = {
    uid = cupUID;
    home = "/var/lib/cup";
    group = "cup";
    isSystemUser = true;
  };

  virtualisation.arion.projects.cup.settings = {
    project.name = "cup";
    networks.proxy.name = "proxy";

    services.cup.service = {
      image = "ghcr.io/sergi0g/cup:latest";
      container_name = "cup";
      restart = "unless-stopped";
      networks = [ "proxy" ];
      command = "serve -p 8000";
      volumes = [
        "/var/run/docker.sock:/var/run/docker.sock:ro"
      ];
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.cup.rule" = "Host(`cup.${domain}`)";
        "traefik.http.routers.cup.middlewares" = "ip-internal@file";
        "traefik.http.routers.cup.service" = "cup";
        "traefik.http.services.cup.loadbalancer.server.port" = "8000";
      };
    };
  };
}

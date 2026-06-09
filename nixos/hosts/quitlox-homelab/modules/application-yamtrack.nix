# Yamtrack
#
# A self hosted media tracker.
#
# --- Deployment ---
#
# - `yamtrack.home.quitlox.dev`
#
{ config, ... }:
let
  domain = config.quitlox.traefik.domain;

  # Unprivileged user for the container
  yamtrackUID = 1502;
  yamtrackGID = 1502;
in
{
  systemd.tmpfiles.rules = [
    "d /var/lib/yamtrack/ 0700 yamtrack yamtrack - -"
  ];

  # Unprivileged user for the container
  users.groups.yamtrack.gid = yamtrackGID;
  users.users.yamtrack = {
    uid = yamtrackUID;
    home = "/var/lib/yamtrack";
    group = "yamtrack";
    isSystemUser = true;
  };

  # Django SECRET_KEY
  sops.secrets."services/yamtrack/secret".owner = "yamtrack";

  virtualisation.arion.projects.yamtrack.settings = {
    project.name = "yamtrack";
    networks.proxy.name = "proxy";
    networks.internal.internal = true;
    services.yamtrack.service = {
      image = "ghcr.io/fuzzygrim/yamtrack";
      container_name = "yamtrack";
      restart = "unless-stopped";
      depends_on = [ "redis" ];
      networks = [
        "proxy"
        "internal"
      ];
      environment = {
        TZ = "Europe/Amsterdam";
        PUID = toString yamtrackUID;
        PGID = toString yamtrackGID;
        URLS = "https://yamtrack.${domain}";
        REDIS_URL = "redis://redis:6379";
        SECRET_FILE = "/run/secrets/yamtrack_secret";
        # Override default ~5s beat tick interval to reduce idle I/O
        CELERY_BEAT_MAX_LOOP_INTERVAL = "180";
      };
      # Override Dockerfile default 45s health check interval to reduce idle I/O
      healthcheck = {
        test = [ "CMD" "wget" "--no-verbose" "--tries=1" "--spider" "http://127.0.0.1:8000/health/" ];
        interval = "5m";
        timeout = "15s";
        start_period = "30s";
        retries = 5;
      };
      volumes = [
        "/var/lib/yamtrack/db:/yamtrack/db"
        "${config.sops.secrets."services/yamtrack/secret".path}:/run/secrets/yamtrack_secret:ro"
      ];
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.yamtrack.rule" = "Host(`yamtrack.${domain}`)";
        # "traefik.http.routers.yamtrack.middlewares" = "ip-internal@file";
        "traefik.http.routers.yamtrack.service" = "yamtrack";
        "traefik.http.services.yamtrack.loadbalancer.server.port" = "8000";
      };
    };
    services.redis.service = {
      container_name = "yamtrack-redis";
      image = "redis:8-alpine";
      restart = "unless-stopped";
      networks = [ "internal" ];
      volumes = [ "redis_data:/data" ];
    };
    docker-compose.volumes.redis_data = { };
  };
}

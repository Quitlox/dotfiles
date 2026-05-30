# Dynamic DNS - ddns-updater
#
# This service uses a Hetzner API Key to automatically update the DNS records
# at Hetzner for the domains `quitlox.dev`, `home.quitlox.dev` and
# `*.home.quitlox.dev` to point to our WAN IP. This service is necessary as most
# ISPs issue dynamic IPs, breaking the DNS record every now and then.
#
#     Service
#
# The container's web UI (:8000) and health server (:9999) are exposed through
# Traefik (via docker labels, on the `proxy` network) on the LAN only:
#   - Web UI:      https://home.quitlox.dev/services/ddns
#   - Healthcheck: https://home.quitlox.dev/services/ddns/health
#
#     References
# - ddns-updater:      https://github.com/qdm12/ddns-updater
{ config, ... }:
let
  domain = config.quitlox.traefik.domain;
in
{
  ##############################################################################
  ### Configuration File                                                     ###
  ##############################################################################
  sops.templates."ddns-updater.json" = {
    owner = "quitlox"; # FIXME: this should be UID 1000 (which happens to be the first user)
    path = "/var/lib/ddns-updater/config.json";
    content = builtins.toJSON {
      settings = [
        {
          provider = "hetznercloud";
          domain = "quitlox.dev,home.quitlox.dev,*.home.quitlox.dev";
          token = config.sops.placeholder."hetzner/cloud-apikey";
          ip_version = "ipv4";
        }
      ];
    };
  };

  # Persistent data dir (holds updates.json: last-seen IP + change history).
  systemd.tmpfiles.rules = [
    "d /var/lib/ddns-updater 0700 1000 1000 - -" # UID 1000 as per docs
  ];

  ##############################################################################
  ### Container                                                              ###
  ##############################################################################
  virtualisation.arion.projects.ddns-updater.settings = {
    project.name = "ddns-updater";
    networks.proxy.name = "proxy";
    services.ddns-updater.service = {
      image = "qmcgaw/ddns-updater:latest";
      container_name = "ddns-updater";
      restart = "unless-stopped";
      networks = [ "proxy" ];
      environment = {
        TZ = "Europe/Amsterdam";
        # How often to check the public IP.
        PERIOD = "5m";
        # Explicitly resolve through external DNS to bypass any locally configured DNS.
        RESOLVER_ADDRESS = "1.1.1.1:53";
        # Serve the web UI under a subpath so Traefik can route /services/ddns.
        ROOT_URL = "/services/ddns";
        # Bind the health server to all interfaces (default 127.0.0.1) so Traefik
        # can reach it over the `proxy` network.
        HEALTH_SERVER_ADDRESS = ":9999";
      };
      volumes = [
        "/var/lib/ddns-updater:/updater/data"
      ];

      ##########################################################################
      ### Traefik routing (LAN only)                                         ###
      ##########################################################################
      labels = {
        "traefik.enable" = "true";
        "traefik.docker.network" = "proxy";

        # Web UI: https://home.quitlox.dev/services/ddns
        "traefik.http.routers.ddns-updater.rule" = "Host(`${domain}`) && PathPrefix(`/services/ddns`)";
        "traefik.http.routers.ddns-updater.entrypoints" = "websecure";
        "traefik.http.routers.ddns-updater.tls.certresolver" = "letsencrypt";
        "traefik.http.routers.ddns-updater.middlewares" = "ip-internal@file";
        "traefik.http.routers.ddns-updater.service" = "ddns-updater";
        "traefik.http.services.ddns-updater.loadbalancer.server.port" = "8000";

        # Healthcheck: https://home.quitlox.dev/services/ddns/health
        # The longer path prefix gives this router priority over the web UI router.
        "traefik.http.routers.ddns-updater-health.rule" = "Host(`${domain}`) && PathPrefix(`/services/ddns/health`)";
        "traefik.http.routers.ddns-updater-health.entrypoints" = "websecure";
        "traefik.http.routers.ddns-updater-health.tls.certresolver" = "letsencrypt";
        "traefik.http.routers.ddns-updater-health.middlewares" = "ip-internal@file,ddns-updater-health-strip";
        "traefik.http.routers.ddns-updater-health.service" = "ddns-updater-health";
        "traefik.http.services.ddns-updater-health.loadbalancer.server.port" = "9999";

        # The health server only answers on "/", so strip the subpath first.
        "traefik.http.middlewares.ddns-updater-health-strip.stripprefix.prefixes" = "/services/ddns/health";
      };
    };
  };
}

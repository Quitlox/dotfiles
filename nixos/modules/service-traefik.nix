# Traefik
#
# Traefik is setup so that other services can easily configure themselves
# to be exposed under specific subdomains/endpoints.
#
# --- Traefik ---
#
# Traefik is a reverse proxy that can dynamically configure routing, which is
# cool. In hindsight, given that this is a Nix configuration, we don't actually
# use the dynamic part to its fullest extent and maybe nginx would've made more
# sense. However, traefik has so far been quite pleasant to use nontheless.
#
# Traefik supports "static" configuration (your plain file based configuration)
# and "dynamic" configuration (such as automatically exposing docker containers
# and such).
#
# --- DNS ---
#
# In order for traefik to be useful, one must configure a DNS service to point
# a specific domain and all its subdomains to this traefik service.
#
{ config, lib, ... }:
let
  cfg = config.quitlox.traefik;
in
{
  imports = [ ./service-traefik-utils.nix ];

  ##############################################################################
  ### variables                                                              ###
  ##############################################################################

  options.quitlox.traefik = {
    domain = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      example = "home.quitlox.dev";
      description = ''
        The domain name of the home network.
      '';
    };
    lan.subnet = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      example = "192.168.178.0/24";
      description = ''
        The mask of the local subnet.

        The "internal" authentication middleware whitelists the local subnet,
        so that routes or domains protected by this middleware can only be
        reached by IPs on the local subnet.
      '';
    };
  };

  config = lib.mkMerge [
    ##############################################################################
    ### configuration                                                          ###
    ##############################################################################

    # HTTP 80, HTTPS 443
    {
      networking.firewall.allowedTCPPorts = [
        80
        443
      ];
    }

    # Enable logging
    {
      services.traefik.staticConfigOptions.log = {
        level = "INFO";
        format = "common";
      };
      # Access logs are noisy, so logged to seperate file
      services.traefik.staticConfigOptions.accessLog = {
        filePath = "${config.services.traefik.dataDir}/access.log";
      };
    }

    # Middleware: authorization - local subnet only
    {
      services.traefik.dynamicConfigOptions.http.middlewares = {
        ip-internal = {
          ipAllowList.sourceRange = [
            "127.0.0.1/32" # localhost
            cfg.lan.subnet # local subnet
            "100.64.0.0/10" # tailscale CGNAT range
          ];
        };
      };
    }

    # Traefik: Expose dashboard through standard entrypoints under /services/traefik
    # http://<LAN-IP>/services/traefik/dashboard/
    {
      services.traefik.staticConfigOptions.api = {
        dashboard = true;
        basePath = "/services/traefik";
      };
      services.traefik.dynamicConfigOptions = {
        http.routers.dashboard = {
          entryPoints = [
            "web"
            "websecure"
          ];
          rule = "(PathPrefix(`/services/traefik/api`) || PathPrefix(`/services/traefik/dashboard`))";
          service = "api@internal"; # "magic" name
          middlewares = [ "ip-internal" ];
        };
      };
    }

    # Traefik: Catchall redirect to HTTPS
    {
      services.traefik.dynamicConfigOptions = {
        catchall-https = {
          entryPoints = [ "websecure" ];
          rule = "HostRegexp(`{host:.+}`)";
          service = "noop@internal";
          tls.certResolver = "letsencrypt";
        };
      };
    }

    # Traefik: Setup docker provide and entrypoints
    {
      services.traefik = {
        enable = true;
        group = "docker";

        # Using the docker provide we can easily configure docker containers
        # through traefik by using labels.
        staticConfigOptions.providers.docker = {
          watch = true;
          exposedByDefault = false;
          # We set network to "proxy", meaning that only docker containers
          # connected to this network can be exposed.
          network = "proxy";
        };

        # The entrypoints are, as suggested by the name, the entrypoints to the
        # server, i.e. the ports on which traefik listens.
        staticConfigOptions.entrypoints = {
          # HTTP :80
          web.address = ":80";
          web.asDefault = true;
          # NOTE: since we use a `.dev` domain, we must always redirect to HTTPS
          web.http.redirections.entryPoint = {
            to = "websecure";
            scheme = "https";
          };
          # HTTS :443
          websecure.address = ":443";
          websecure.asDefault = true;
          websecure.http.tls.certResolver = "letsencrypt";
          # websecure.http.tls.domains = [ { main = "home.quitlox.dev"; sans = ["*.home.quitlox.dev" ]; } ];

        };
      };
    }
  ];
}

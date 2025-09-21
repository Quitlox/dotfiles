# Traefik
#
# Traefik is setup so that other services can easily configure themselves
# to be exposed under specific subdomains/endpoints.
#
#     Traefik
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
#     DNS
#
# In order for traefik to be useful, one must configure a DNS service to point
# a specific domain and all its subdomains to this traefik service.
#
{ config, lib, ... }:
let 
  cfg = config.quitlox.traefik;
in
{
  ##############################################################################
  ### variables                                                              ###
  ##############################################################################

  options.quitlox.traefik = {
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
    ### traefik                                                                ###
    ##############################################################################

    # HTTP 80, HTTPS 443, INTERNAL 8080
    { networking.firewall.allowedTCPPorts = [ 80 443 8080 ]; }

    # Enable logging
    { services.traefik.staticConfigOptions.accessLog = { }; }

    # Middleware: authorization - local subnet only
    {
      services.traefik.dynamicConfigOptions.http.middlewares = {
        ip-internal = {
          ipAllowList.sourceRange = [
            "127.0.0.1/32" # localhost
            cfg.lan.subnet # local subnet
          ];
        };
      };
    }

    # Traefik: Expose dasbhoard on internal network
    # http://<LAN-IP>:8080/dashboard/
    {
      services.traefik.staticConfigOptions.api.dashboard = true;
      services.traefik.dynamicConfigOptions = {
        http.routers.dashboard = {
          entryPoints = [ "internal" ];
          rule = "(PathPrefix(`/api`) || PathPrefix(`/dashboard`))";
          service = "api@internal"; # "magic" name
          middlewares = [ "ip-internal" ];
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
          # HTTS :443
          websecure.address = ":443";
          websecure.asDefault = true;
          websecure.http.tls.certResolver = "letsencrypt";
          # Internal :8080
          internal.address = ":8080";
        };
      };
    }
  ];
}

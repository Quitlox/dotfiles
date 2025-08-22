# Traefik - Reverse Proxy
#
# Exposed:
# - Traefik Dashboard: quitlox-pi.local:8080/dashboard [internal]

{ pkgs, config, ... }:
{
  environment.systemPackages = [ pkgs.traefik ];
  networking.firewall.allowedTCPPorts = [ 80 443 8080 ];

  services.traefik = {
    enable = true;
    group = "docker";

    staticConfigOptions = {
      api.dashboard = true;

      providers = {
        docker = {
          network = "proxy";
          watch = true;
          exposedByDefault = false;
        };
      };

      entryPoints = {
        web = {
          address = ":80";
          asDefault = true;
        };
        websecure = {
          address = ":443";
          asDefault = true;
          http.tls.certResolver = "letsencrypt";
        };
        # Internal port not exposed to the internet
        internal = {
          address = ":8080";
        };
      };

      certificatesResolvers.letsencrypt.acme = {
        email = "kevin.witlox@upcmail.nl";
        storage = "${config.services.traefik.dataDir}/acme.json";
        caServer = "https://acme-staging-v02.api.letsencrypt.org/directory";
        httpChallenge.entryPoint = "web";
      };
    };

    dynamicConfigOptions = {
      http = {
        routers = {
          # Dashboard: Lock to Internal IPs
          dashboard = {
            entryPoints = [ "internal" ];
            rule = "(PathPrefix(`/api`) || PathPrefix(`/dashboard`))";
            service = "api@internal";
            middlewares = [ "ip-internal" ];
          };
        };
        middlewares = {
          # Auth: Internal IPs only
          ip-internal = {
            ipAllowList = {
              sourceRange = [
                "127.0.0.1/32" # localhost
                "192.168.178.1/24" # local subnet
              ];
            };
          };
        };
      };
    };
  };
}

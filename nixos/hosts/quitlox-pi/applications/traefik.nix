{ pkgs, config, ... }:
{
  environment.systemPackages = [ pkgs.traefik ];
  networking.firewall.allowedTCPPorts = [ 80 8080 ];

  services.traefik = {
    enable = true;
    group = "docker";

    staticConfigOptions = {
      api.dashboard = true;
      api.insecure = true;
      ping = {};

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
      };

      certificatesResolvers.letsencrypt.acme = {
        email = "kevin.witlox@upcmail.nl";
        storage = "${config.services.traefik.dataDir}/acme.json";
        caServer = "https://acme-staging-v02.api.letsencrypt.org/directory";
        httpChallenge.entryPoint = "web";
      };
    };
  };
}

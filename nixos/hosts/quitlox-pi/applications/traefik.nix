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
      };

      log = {
        level = "INFO";
        filePath = "${config.services.traefik.dataDir}/traefik.log";
        format = "json";
      };
    };
  };
}

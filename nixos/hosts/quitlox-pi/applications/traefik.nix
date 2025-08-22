{ pkgs, config, ... }:
{
  environment.systemPackages = [ pkgs.traefik ];

  services.traefik = {
    enable = true;
    group = "docker";

    staticConfigOptions = {
      api.dashboard = true;
      api.insecure = true;

      providers = {
        docker = {};
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

    dynamicConfigOptions = {
      http.routers = { };
      http.services = { };
    };
  };
}

{ config, ... }:
{
  services.traefik = {
    enable = true;

    staticConfigOptions = {
      api.dashboard = true;
      api.insecure = true;

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

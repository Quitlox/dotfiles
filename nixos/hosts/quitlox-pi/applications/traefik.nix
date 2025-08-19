{ config, ...}:
{
  services.traefik = {
  enable = true;

  staticConfigOptions = {
    entryPoints = {
      web = {
        address = ":80";
        asDefault = true;
        http.redirections.entrypoint = {
          to = "websecure";
          scheme = "https";
        };
      };

      websecure = {
        address = ":443";
        asDefault = true;
        http.tls.certResolver = "letsencrypt";
      };
    };

    log = {
      level = "INFO";
      filePath = "${config.services.traefik.dataDir}/traefik.log";
      format = "json";
    };

    certificatesResolvers.letsencrypt.acme = {
      email = "kevin.witlox@upcmail.nl";
      storage = "${config.services.traefik.dataDir}/acme.json";
      httpChallenge.entryPoint = "web";
      caServer = "https://acme-staging-v02.api.letsencrypt.org/directory"; # use staging temporarily
    };

    api.dashboard = true;
    # Access the Traefik dashboard on <Traefik IP>:8080 of your server
    api.insecure = true;
  };

  dynamicConfigOptions = {
    http.routers = {};
    http.services = {};
  };
};
}

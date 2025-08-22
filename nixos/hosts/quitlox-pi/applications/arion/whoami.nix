{
  project.name = "whoami";
  services = {
    whoami = {
      service = {
        image = "traefik/whoami";
        labels = {
            "traefik.enable" = "true";
            "traefik.http.routers.whoami.rule" = "Host(`whoami.kevinwitlox.nl`) || Host(`whoami.quitlox-pi.local`)";
            "traefik.http.routers.whoami.entrypoints" = "web";
            "traefik.http.routers.whoami.tls" = "false";
            "traefik.http.services.whoami.loadbalancer.server.port" = "80";
        };
      };
    };
  };
}

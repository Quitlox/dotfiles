{
  project.name = "whoami";
  networks.proxy = { };
  services = {
    whoami = {
      service = {
        image = "traefik/whoami";
        networks = [ "proxy" ];
        restart = "unless-stopped";
        labels = {
            "traefik.enable" = "true";
            "traefik.docker.network" = "proxy";
            "traefik.http.routers.whoami.rule" = "Host(`whoami.quitlox-pi.local`)";
            "traefik.http.routers.whoami.entrypoints" = "web";
        };
      };
    };
  };
}

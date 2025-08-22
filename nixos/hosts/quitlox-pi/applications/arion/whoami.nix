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
            "traefik.http.routers.whoami.rule" = "Host(`whoami.kevinwitlox.nl`) || Host(`whoami.quitlox-pi.local`) || Host(`whoami.quitlox-pi`)";
            "traefik.http.routers.whoami.entrypoints" = "web";
        };
      };
    };
  };
}

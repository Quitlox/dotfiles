# Glance
{ config, ... }:
{
  # `glance.env`
  sops.templates."glance.env" = {
    owner = "glance";
    group = "root";
    content = ''
      RADARR_APIKEY=${config.sops.placeholder."services/radarr/apikey"}
      SONARR_APIKEY=${config.sops.placeholder."services/sonarr/apikey"}
      PROWLARR_APIKEY=${config.sops.placeholder."services/prowlarr/apikey"}
    '';
  };

  services.glance.enable = true;
  services.glance.openFirewall = true;
  services.glance.environmentFile = config.sops.templates."glance.env".path;
  services.glance.settings.pages = [
    {
      name = "HomeLab";
      columns = [
        {
          size = "full";
          widgets = [
            {
              type = "monitor";
              cache = "1m";
              title = "Media Services";
              style = "compact";
              sites = [
                {
                  title = "Jellyfin";
                  icon = "sh:jellyfin";
                  url = "https://jellyfin.home.quitlox.dev";
                  check-url = "https://jellyfin.home.quitlox.dev/health";
                }
                {
                  title = "Prowlarr";
                  icon = "sh:prowlarr";
                  url = "https://prowlarr.home.quitlox.dev";
                  check-url = "https://prowlarr.home.quitlox.dev/api/v1/health?apikey=\${PROWLARR_APIKEY}";
                }
                {
                  title = "Radarr";
                  icon = "sh:radarr";
                  url = "https://radarr.home.quitlox.dev";
                  check-url = "https://radarr.home.quitlox.dev/api/v3/health?apikey=\${RADARR_APIKEY}";
                }
                {
                  title = "Sonarr";
                  icon = "sh:sonarr";
                  url = "https://sonarr.home.quitlox.dev";
                  check-url = "https://sonarr.home.quitlox.dev/api/v3/health?apikey=\${SONARR_APIKEY}";
                }
              ];
            }
          ];
        }
      ];
    }
  ];
  services.glance.settings.server.host = "0.0.0.0";
  services.glance.settings.server.port = 3101;

  # Expose through traefik
  quitlox.traefik.expose-internal = {
    glance.port = 3101;
  };
}

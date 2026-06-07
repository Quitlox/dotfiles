# Glance
{  ... }:
{
  services.glance.enable = true;
  services.glance.openFirewall = true;
  # services.glance.settings = {};
  # services.glance.environmentFile = "";
  # services.glance.settings.pages = {};
  services.glance.settings.server.host = "0.0.0.0";
  services.glance.settings.server.port = 3101;

  # Expose through traefik
  quitlox.traefik.expose-internal = {
    glance.port = 3101;
  };
}

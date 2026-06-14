# Home Assistant - Smart home hub.
#
# We run the official Home Assistant container via docker. We do not use the
# full HomeAssistant VM (HOAS); the addons-apps can be configured natively
# through NixOS.
#
# Deployment: 
#   - https://homeassistant.home.quitlox.dev
#
# Companion services:
#   - python-matter-server (Matter support)
#
# ----- Networking -----
#
# HomeAssistant and python-matter are both ran using host networking, to allow
# for proper discovery. This also means the service is not on the traefik
# `proxy` network, so the port is exposed explicitely instead.
#
{ config, ... }:
{
  # Persistent state (root-owned; HA runs as root)
  systemd.tmpfiles.rules = [
    "d /var/lib/homeassistant        0700 root root - -"
    "d /var/lib/homeassistant/config 0700 root root - -"
    "d /var/lib/matter-server        0700 root root - -"
  ];

  # Minimal seed configuration if absent, configures access through reverse-proxy.
  system.activationScripts.homeassistant-config = {
    deps = [ "users" "groups" ];
    text = ''
      cfg=/var/lib/homeassistant/config/configuration.yaml
      if [ ! -f "$cfg" ]; then
        install -m 0644 -o root -g root /dev/stdin "$cfg" <<'EOF'
      default_config:

      http:
        use_x_forwarded_for: true
        trusted_proxies:
          - 127.0.0.1
          - ::1

      automation: !include automations.yaml
      script: !include scripts.yaml
      scene: !include scenes.yaml
      EOF
      fi
    '';
  };

  virtualisation.arion.projects.homeassistant.settings = {
    project.name = "homeassistant";

    services.homeassistant.service = {
      image = "ghcr.io/home-assistant/home-assistant:stable";
      container_name = "homeassistant";
      restart = "unless-stopped";
      network_mode = "host";
      environment.TZ = "Europe/Amsterdam";
      volumes = [
        "/var/lib/homeassistant/config:/config"
        "/etc/localtime:/etc/localtime:ro"
        "/run/dbus:/run/dbus:ro" # for host integrations (e.g. Bluetooth later)
      ];
    };

    # Matter controller HA talks to over ws://localhost:5580/ws
    services.matter-server.service = {
      image = "ghcr.io/home-assistant-libs/python-matter-server:stable";
      container_name = "matter-server";
      restart = "unless-stopped";
      network_mode = "host";
      volumes = [
        "/var/lib/matter-server:/data"
        "/run/dbus:/run/dbus:ro"
      ];
    };
  };

  # Expose via Traefik (host-networked -> loopback), internal-only (ip-internal).
  quitlox.traefik.expose-internal.homeassistant.port = 8123;

  # Host-network discovery + Matter commissioning need these on the LAN.
  networking.firewall.allowedUDPPorts = [ 5353 5540 ]; # mDNS, Matter
  networking.firewall.allowedTCPPorts = [ 8123 5580 ]; # HA UI (LAN direct), Matter ws
}

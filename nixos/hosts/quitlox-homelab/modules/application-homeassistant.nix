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
# ----- Configuration -----
#
# The YAML configuration of Home Assistant is stored in this repository and
# deployed on every rebuild. Home Assistant is only party declarative, most
# configuration is stored in its database.
#
# After rebuilding, Home Assistant must be restarted: 
#   - docker restart homeassistant
#
{ config, lib, ... }:
let
  mkInstallCmd = name: _type:
    "install -m 664 -o root -g homeassistant ${./homeassistant/config/${name}} /var/lib/homeassistant/config/${name}";
  configFiles = lib.filterAttrs (_: type: type == "regular") (builtins.readDir ./homeassistant/config);
  configInstallCmds = lib.mapAttrsToList mkInstallCmd configFiles;
in
{
  users.groups.homeassistant.gid = 1507;

  users.users.code.extraGroups = [ "homeassistant" ];

  # Persistent state directories
  system.activationScripts.homeassistant-config = {
    deps = [ "users" "groups" ];
    text = ''
      install -d -m 2770 -o root -g homeassistant /var/lib/homeassistant
      install -d -m 2770 -o root -g homeassistant /var/lib/homeassistant/config
      install -d -m 2770 -o root -g homeassistant /var/lib/homeassistant/bridge
      install -d -m 0700 -o root -g root /var/lib/matter-server
      ${lib.concatStringsSep "\n      " configInstallCmds}
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
        "/var/lib/homeassistant/bridge:/bridge" # container -> host action bridge
        "/etc/localtime:/etc/localtime:ro"
        "/run/dbus:/run/dbus:ro" # for host integrations (e.g. Bluetooth later)
      ];
      # Zigbee coordinator: Sonoff Dongle Plus MG24 (Silicon Labs EFR32MG24, EZSP)
      # Stable by-id path to avoid ttyUSB* renumbering across reboots.
      devices = [
        "/dev/serial/by-id/usb-SONOFF_SONOFF_Dongle_Plus_MG24_d2abfb6daca2ef11a0cb8c6661ce3355-if00-port0:/dev/serial/by-id/usb-SONOFF_SONOFF_Dongle_Plus_MG24_d2abfb6daca2ef11a0cb8c6661ce3355-if00-port0"
      ];
    };

    # Matter controller HA talks to over ws://localhost:4003/ws
    services.matter-server.service = {
      image = "ghcr.io/home-assistant-libs/python-matter-server:stable";
      container_name = "matter-server";
      restart = "unless-stopped";
      network_mode = "host";
      # Override default port (5580) -> 4003.
      # Must include original CMD args (--storage-path, --paa-root-cert-dir) as
      # `command` replaces the Dockerfile CMD entirely (ENTRYPOINT stays).
      command = "--storage-path /data --paa-root-cert-dir /data/credentials --port 4003";
      volumes = [
        "/var/lib/matter-server:/data"
        "/run/dbus:/run/dbus:ro"
      ];
    };
  };

  # Expose via Traefik (host-networked -> loopback), internal-only (ip-internal).
  quitlox.traefik.expose-internal.homeassistant.port = 4002;

  # Host-network discovery + Matter commissioning need these on the LAN.
  networking.firewall.allowedUDPPorts = [ 5353 5540 ]; # mDNS, Matter
  networking.firewall.allowedTCPPorts = [ 4002 4003 ]; # HA UI (LAN direct), Matter ws
}

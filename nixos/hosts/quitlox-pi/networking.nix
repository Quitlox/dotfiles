{ config, lib, ... }:
{
  # TODO: Remove?
  networking.useNetworkd = true;

  # Multicast DNS - Make quitlox-pi.local reachable on local network
  networking.firewall.allowedUDPPorts = [ 5353 ];
  systemd.network.networks = {
    "99-ethernet-default-dhcp".networkConfig.MulticastDNS = "yes";
    "99-wireless-client-dhcp".networkConfig.MulticastDNS = "yes";
  };

  # WiFi Configuration (wpa_supplicant)
  networking.wireless.iwd.enable = false; # Disable iwd since we're using wpa_supplicant
  networking.wireless.userControlled.enable = true; # Allow manual configuration (through wpa_cli)
  networking.wireless = {
    enable = true;
    secretsFile = config.sops.templates."wifi".path;
    networks = {
      "Wifi in de Trein" = {
        pskRaw = "ext:psk_wifi_home";
      };
    };
  };

  # ----- Lifted from srvos -----

  # Allow PMTU / DHCP
  networking.firewall.allowPing = true;

  # Keep dmesg/journalctl -k output readable by NOT logging
  # each refused connection on the open internet.
  networking.firewall.logRefusedConnections = lib.mkDefault false;
  
  # Do not take down the network for too long when upgrading,
  # This also prevents failures of services that are restarted instead of stopped.
  # It will use `systemctl restart` rather than stopping it with `systemctl stop`
  # followed by a delayed `systemctl start`.
  systemd.services = {
    systemd-networkd.stopIfChanged = false;
    # Services that are only restarted might be not able to resolve when resolved is stopped before
    systemd-resolved.stopIfChanged = false;
  };

  # The notion of "online" is a broken concept
  # https://github.com/systemd/systemd/blob/e1b45a756f71deac8c1aa9a008bd0dab47f64777/NEWS#L13
  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.network.wait-online.enable = false;
}

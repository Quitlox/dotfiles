{ config, ... }:
{
  # This is mostly portions of safe network configuration defaults that
  # nixos-images and srvos provide

  networking.useNetworkd = true;
  # mdns
  networking.firewall.allowedUDPPorts = [ 5353 ];
  systemd.network.networks = {
    "99-ethernet-default-dhcp".networkConfig.MulticastDNS = "yes";
    "99-wireless-client-dhcp".networkConfig.MulticastDNS = "yes";
  };

  # This comment was lifted from `srvos`
  # Do not take down the network for too long when upgrading,
  # This also prevents failures of services that are restarted instead of stopped.
  # It will use `systemctl restart` rather than stopping it with `systemctl stop`
  # followed by a delayed `systemctl start`.
  systemd.services = {
    systemd-networkd.stopIfChanged = false;
    # Services that are only restarted might be not able to resolve when resolved is stopped before
    systemd-resolved.stopIfChanged = false;
  };

  # Disable iwd since we're using wpa_supplicant
  networking.wireless.iwd.enable = false;
  networking.wireless.userControlled.enable = true;
  # Use wpa_supplicant for declarative WiFi configuration
  networking.wireless = {
    enable = true;
    secretsFile = config.sops.templates."wifi".path;
    networks = {
      "Wifi in de Trein" = {
        pskRaw = "ext:psk_wifi_home";
      };
    };
  };
  
}

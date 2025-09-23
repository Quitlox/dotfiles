{ config, lib, ... }:
{
  # Ethernet
  networking.useDHCP = false; # enabled by default, conflicts with networkd
  systemd.network.enable = true;
  systemd.network.networks."10-eth" = {
    matchConfig.Name = "end0";
    networkConfig.MulticastDNS = "yes"; # Resolve <hostname>.local
    # Static configuration
    address = [ "192.168.178.3/24" ];
    routes = [ { Gateway = "192.168.178.1"; } ];
    # Dynamic configuration
    networkConfig.DHCP = "ipv4";
    networkConfig.IPv6AcceptRA = true;
    # Both the static and dynamic IP will be assigned, but one can be used as
    # a fallback for the other.
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

  # WiFi Password
  sops.secrets."pass-wifi" = { };
  sops.templates."wifi" = {
    content = ''
      psk_wifi_home=${config.sops.placeholder.pass-wifi}
    '';
  };

  # Multicast DNS - Resolve <hostname>.local
  networking.firewall.allowedUDPPorts = [ 5353 ];

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

  # ----- Lifted from srvos -----

  # The notion of "online" is a broken concept
  # https://github.com/systemd/systemd/blob/e1b45a756f71deac8c1aa9a008bd0dab47f64777/NEWS#L13
  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.network.wait-online.enable = false;
}

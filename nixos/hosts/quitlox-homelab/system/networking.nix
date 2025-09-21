{ config, lib, ... }:
{
  # Ethernet
  networking.useDHCP = false; # enabled by default, conflicts with networkd
  systemd.network.enable = true;
  systemd.network.networks."10-eth" = {
    matchConfig.Name = "enp0s31f6";
    # Static configuration
    address = [ "192.168.178.2/24" ];
    routes = [ { Gateway = "192.168.178.1"; } ];
    # Dynamic configuration
    networkConfig.DHCP = "ipv4";
    networkConfig.IPv6AcceptRA = true;
    # Both the static and dynamic IP will be assigned, but one can be used as
    # a fallback for the other.
  };

  # Multicast DNS - Make <hostname>.local reachable on local network
  networking.firewall.allowedUDPPorts = [ 5353 ];
  systemd.network.networks = {
    "99-ethernet-default-dhcp".networkConfig.MulticastDNS = "yes";
  };

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
}

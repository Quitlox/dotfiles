{ config, lib, ... }:
{
  # disable global DHCP; legacy option that conflicts with `systemd.network`
  networking.useDHCP = false; 

  # Bit of backstory here. So once upon a time there was
  # `networking.interfaces.*` to configure networking. This was translated to
  # a bunch of shell scripts that configured networking for you using `dhcpd` .
  #
  # In modern day, there is `systemd.network` which gives more direct access to
  # `systemd-networkd`, allowing one to directly configure interfaces and
  # networks. This is turned on using `systemd.network.enable`.
  # 
  # The option `network.useNetworkd`, when `true`, implies
  # `systemd.network.enable` but *additionally* enables a translation layer
  # that translates the old `networking.interfaces.*` into `systemd.network`
  # configuration. The wiki discourages its usage.
  #
  # We just directly use `systemd.network` so we can ignore
  # `network.interfaces.*` and the `networking.useNetworkd`.
  networking.useNetworkd = false;

  # Ethernet Interface
  systemd.network.enable = true;
  systemd.network.networks."10-eth" = {
    matchConfig.Name = "enp0s31f6";
    networkConfig.MulticastDNS = "yes"; # Resolve <hostname>.local
    # Static configuration
    # address = [ "192.168.178.2/24" ];
    # routes = [ { Gateway = "192.168.178.1"; } ];
    # Dynamic configuration
    networkConfig.DHCP = "ipv4";
    networkConfig.IPv6AcceptRA = true;
    # Both the static and dynamic IP will be assigned, but one can be used as
    # a fallback for the other.
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
}

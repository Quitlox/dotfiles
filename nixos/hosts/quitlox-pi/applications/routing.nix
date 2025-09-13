# Routing - DNS and Traefik
#
# This module sets up this device as a DNS server intended to be used on the
# local home network. The DNS server will ensure that home.<mydomain> and its
# subdomains will be routed to this server. Other DNS requests will be
# delegated to a public resolver.
#
# Traefik is also setup so that other services can easily configure themselves
# to be exposed under specific subdomains/endpoints.
#
#     Traefik
#
# Traefik is a reverse proxy that can dynamically configure routing, which is
# cool. In hindsight, given that this is a Nix configuration, we don't actually
# use the dynamic part to its fullest extent and maybe nginx would've made more
# sense. However, traefik has so far been quite pleasant to use nontheless.
#
# Traefik supports "static" configuration (your plain file based configuration)
# and "dynamic" configuration (such as automatically exposing docker containers
# and such).
#
#     Setup
#
# Setup - Method 1: DHCP + DNS
#
# 1. Disable DHCP on router
# 2. Enable DHCP and DNS on server
#
# Setup - Method 2: DNS only
#
# 1. Reserve an IP for the server on the Router
# 2. Point the DNS of the router to the server
#
# Setup - Optional: Expose to internet
#
# 1. Enable port forwarding
#    Port forward port 80 and 443 to the server IP
# 2. Add DNS records
#    - A home -> reserved IP
#    - A *.home -> reserved IP
#
{ pkgs, config, lib, ... }:
let 
  cfg = config.quitlox.home;
in
{
  ##############################################################################
  ### variables                                                              ###
  ##############################################################################

  options.quitlox.home = {
    domain = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      example = "home.quitlox.dev";
      description = ''
        The domain name of the home network.

        To support HTTPS, the domain must be registered.
      '';
    };
    lan.ipv4 = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      example = "192.168.178.101";
      description = ''
        The IP under which this device is known in the local subnet.

        To find/obtain a reserved IPv4 on the local subnet:
          1. Navigate to smartwifiweb.ziggo.nl
          2. Router > Geavanceerde instellingen > DHCP > Lijst IPv4 gereserveerd 
          3. Add / Find the device

        If the server is configured to be the DHCP server
        (home.quitlox.dhcp.enable = true), then this address will be
        configured using a static network configuration. Ensure that this ip
        is outside of the DHCP pool.
      '';
    };
    lan.subnet = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      example = "192.168.178.0/24";
      description = ''
        The mask of the local subnet.
      '';
    };

    dns.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable dnsmasq DNS (authoritative for domain; forward others).";
    };

    dns.public = lib.mkOption {
      type = with lib.types; nullOr (listOf str);
      default = null;
      example = [ "1.1.1.1" "9.9.9.9" ];
      description = ''
        The public DNS resolvers to use.

        This server should be configured as the DNS server on the local network
        via the router configuration. This server will delegate requests to the
        public DNS resolvers.
      '';
    };

    dhcp.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable dnsmasq DHCP on the LAN (advertises the Pi as DNS).";
    };

    dhcp.interface = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      example = "end0";
      description = "LAN NIC to serve DHCP on.";
    };

    dhcp.range = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      example = "192.168.178.100,192.168.178.200,12h";
      description = "DHCPv4 pool in dnsmasq format start,end,lease-time.";
    };

    dhcp.router = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      example = "192.168.178.1";
      description = "Default gateway to advertise.";
    };
  };

  config = lib.mkMerge [
  ##############################################################################
  ### assertions                                                             ###
  ##############################################################################
    {
      assertions = [
        {
          assertion = (!cfg.dhcp.enable) || (cfg.dhcp.interface != null && cfg.dhcp.range != null && cfg.dhcp.router != null);
          message = "quitlox.home.dhcp.* must be set (interface, range, router) when quitlox.home.dhcp.enable = true.";
        }
        {
          assertion = (!cfg.dns.enable) || (cfg.dns.public != null);
          message = "quitlox.home.dns.* must be set (public) when quitlox.home.dns.enable = true.";
        }
      ];
    }

    ##############################################################################
    ### dnsmasq                                                                ###
    ##############################################################################
    # We configure a simple DNS server that resolves all subdomains of the
    # domain to ourselves.

    (lib.mkIf cfg.dns.enable {
      networking.firewall.allowedTCPPorts = lib.mkAfter [ 53 ];
      networking.firewall.allowedUDPPorts = lib.mkAfter [ 53 ];
    })
    (lib.mkIf cfg.dhcp.enable {
      networking.firewall.allowedUDPPorts = lib.mkAfter [ 67 ];
    })

    {
      services.dnsmasq = (lib.mkIf (cfg.dns.enable || cfg.dhcp.enable) {
        enable = true;

        settings =
          # --- DNS settings (authoritative for your internal domain; forward others) ---
          (lib.optionalAttrs cfg.dns.enable {
            # We bind specifically to the external ip
            # (systemd-resolved already binds port 53 on localhost)
            listen-address = [ cfg.lan.ipv4 ];
            bind-interfaces = true;
            # Upstream resolvers for non-local names
            server = cfg.dns.public;
            no-resolv = true; # do not read /etc/resolv.conf
            strict-order = true; # try servers in the order listed
            # Treat the zone as local/authoritative and do not forward it upstream
            local = [ "/${cfg.domain}/" ];
            # Wildcard: *.home.quitlox.dev -> this ip
            address = [ "/${cfg.domain}/${cfg.lan.ipv4}" ];

            domain-needed = true;
            bogus-priv = true;
          })
          //
          # --- DHCP settings (only if enabled) ---
          (lib.optionalAttrs cfg.dhcp.enable {
            interface = cfg.dhcp.interface;
            dhcp-authoritative = true;
            log-dhcp = true;
            dhcp-range = [ cfg.dhcp.range ];
            dhcp-option = [
              "option:router,${cfg.dhcp.router}"
              "option:dns-server,${cfg.lan.ipv4}"
            ];
          });
      });
    }
    
    # DHCP - If enabled, we need to set our own IP statically.
    (lib.mkIf cfg.dhcp.enable {
      systemd.network.networks."10-lan" = {
        matchConfig.Name = cfg.dhcp.interface;
        address = [ "${cfg.lan.ipv4}/24" ];
        routes  = [ { Gateway = cfg.dhcp.router; } ];

        networkConfig.MulticastDNS = "yes";
      };
    })

    ##############################################################################
    ### traefik                                                                ###
    ##############################################################################

    # HTTP 80, HTTPS 443, INTERNAL 8080
    { networking.firewall.allowedTCPPorts = [ 80 443 8080 ]; }

    # Enable logging
    { services.traefik.staticConfigOptions.accessLog = { }; }

    # Middleware: authorization - local subnet only
    {
      services.traefik.dynamicConfigOptions.http.middlewares = {
        ip-internal = {
          ipAllowList.sourceRange = [
            "127.0.0.1/32" # localhost
            cfg.lan.subnet # local subnet
          ];
        };
      };
    }

    # Traefik: Expose dasbhoard on internal network
    # http://<LAN-IP>:8080/dashboard/
    {
      services.traefik.staticConfigOptions.api.dashboard = true;
      services.traefik.dynamicConfigOptions = {
        http.routers.dashboard = {
          entryPoints = [ "internal" ];
          rule = "(PathPrefix(`/api`) || PathPrefix(`/dashboard`))";
          service = "api@internal"; # "magic" name
          middlewares = [ "ip-internal" ];
        };
      };
    }

    # Traefik: Setup docker provide and entrypoints
    {
      services.traefik = {
        enable = true;
        group = "docker"; # FIXME: is this necessary?

        # Using the docker provide we can easily configure docker containers
        # through traefik by using labels. 
        staticConfigOptions.providers.docker = {
          watch = true;
          exposedByDefault = false;
          # We set network to "proxy", meaning that only docker containers
          # connected to this network can be exposed.
          network = "proxy";
        };

        # The entrypoints are, as suggested by the name, the entrypoints to the
        # server, i.e. the ports on which traefik listens.
        staticConfigOptions.entrypoints = {
          # HTTP :80
          web.address = ":80";
          web.asDefault = true;
          # HTTS :443
          websecure.address = ":443";
          websecure.asDefault = true;
          websecure.http.tls.certResolver = "letsencrypt";
          # Internal :8080
          internal.address = ":8080";
        };
      };
    }
  ];
}

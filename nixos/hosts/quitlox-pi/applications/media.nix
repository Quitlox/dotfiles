# Media Server
#
# Systemd Unit             Port  User       Data                 Description
# jellyfin.service         8096  jellyfin   /var/lib/jellyfin    The Media Server
# prowlarr.service         2101  prowlarr   /var/lib/prowlarr    Torrent index manager
# radarr.service           2102  radarr     /var/lib/radarr      Movie collection manager
# sonarr.service           2103  sonarr     /var/lib/sonarr      Series collection manager
# jellyseerr.service       2108  jellyseer  /var/lib/jellyseerr  Media Discovery 
# arion-profilarr.service  2109  -          /var/lib/profilarr   Configuration manager (for profiles, quality)
# qbittorent.service       2111  -          /var/lib/profilarr   QBittorrent Web UI
#
# Storage
#   - /srv/media/movies
#   - /srv/media/tvshows
#   - /srv/media/torrents
# 
# VPN:
#   - AirVPN is configured
# 
# Notes:
#   - All services share the `media` group for access to /srv/media
#     - NOTE - I think this may not actually be necessary for some services
#   - Passwords for services can be found in `nixos/secrets/secrets.yaml`
#   - The services cannot be fully declaratively my setup unfortunately, so we use a combination of hacks
#       - `radarr-settings-sync.service`: one-off script that configures UI settings
#       - `sonarr-settings-sync.service`: one-off script that configures UI settings

# - The following guide is what I used to get started
#   It doesn't cover exactly my setup, but it's a good starting point for catching up.
#   https://web.archive.org/web/20250822223330/https://www.fuzzygrim.com/posts/media-server
#
# Notes:
{ nixpkgs, config, lib, pkgs, ... }:
let
  # Package our servarr_sync_settings script
  script_servarr_settings_sync_env = pkgs.python3.withPackages (ps: [
    ps.requests
  ]);
  script_servarr_settings_sync = pkgs.writeScriptBin "servarr_settings_sync" ''
    #!${script_servarr_settings_sync_env}/bin/python
    ${builtins.readFile ./include/media_servarr_sync_settings.py}
  '';

  sonarr_apikey = "services/sonarr/apikey";
  radarr_apikey = "services/radarr/apikey";
  prowlarr_apikey = "services/prowlarr/apikey";
in
{
  ##############################################################################
  ### Storage                                                                ###
  ##############################################################################

  # Media Directories
  users.groups.media = { };
  systemd.tmpfiles.rules = [
    "d /var/lib/prowlarr/       0700 prowlarr media - -" # See prowlarr
    "d /var/lib/profilarr/          0700 root media - -" # See prowlarr
    "d /srv/media                   2775 root media - -"
    "d /srv/media/movies            2775 root media - -"
    "d /srv/media/tvshows           2775 root media - -"
    "d /srv/media/torrents          2775 root media - -"
  ];

  ##############################################################################
  ### Jellyfin - Media Server                                                ###
  ##############################################################################
  # Setup:
  # 1. Create user account (upon setup)
  # 2. Create Libraries
  #     - Either immediately on setup or Dashboard > Libraries
  #     - Create: "Movies" with folder "/srv/media/movies"
  #     - Create: "Shows" with folder "/srv/media/tvshows"

  environment.systemPackages = with pkgs; [ jellyfin jellyfin-web jellyfin-ffmpeg ];

  services.jellyfin.enable = true;
  services.jellyfin.group = "media";
  services.jellyfin.openFirewall = true;
  # Always prioritise Jellyfin IO
  systemd.services.jellyfin.serviceConfig.IOSchedulingPriority = 0;

  ##############################################################################
  ### Prowlarr - Indexer manager                                             ###
  ##############################################################################
  # Setup:
  # 1. Add Indexers
  #     - Indexers: Add Indexer
  # 2. Connect Servarrs
  #     - Settings > Apps: Press the Plus Button
    #     - Add Sonarr:
    #         - Prowlarr Server = "http://quitlox-pi.local:2101"
    #         - Sonarr Server = "http://quitlox-pi.local:2103"
    #         - API Key = "XXX"
    #     - Add Radarr:
    #         - Prowlarr Server = "http://quitlox-pi.local:2101"
    #         - Radarr Server = "http://quitlox-pi.local:2102"
    #         - API Key = "XXX"
  #     - Setting > Apps: Sync App Indexers

  services.prowlarr.enable = true;
  services.prowlarr.openFirewall = true;
  services.prowlarr.settings.server.port = 2101;
  # For some reason, the NixOS module of prowlarr does not have support for "user" and "group"
  # We manually configure the user and group of the prowlarr service
  # This is based on the NixOS modules for sonarr and radarr
  # Note we also add an entry to `systemd.tmpfiles.rules` (below)
  systemd.services.prowlarr.serviceConfig.User = "prowlarr";
  systemd.services.prowlarr.serviceConfig.Group = "media";
  systemd.services.prowlarr.serviceConfig.DynamicUser = lib.mkForce false;
  systemd.services.prowlarr.serviceConfig.ExecStart = lib.mkForce "${lib.getExe config.services.prowlarr.package} -nobrowser -data=/var/lib/prowlarr/";
  users.users.prowlarr = { 
    home = "/var/lib/prowlarr/"; 
    group = "media"; 
    isSystemUser = true;
  };

  services.prowlarr.environmentFiles = [ config.sops.templates."prowlarr.env".path ];
  sops.secrets."${prowlarr_apikey}" = { owner = "root"; group = "media"; };
  sops.templates."prowlarr.env" = {
    content = ''
      PROWLARR__AUTH__APIKEY=${config.sops.placeholder."${prowlarr_apikey}"}
      PROWLARR__AUTH__METHOD=Forms
      PROWLARR__AUTH__REQUIRED=DisabledForLocalAddresses
    '';
  };

  ##############################################################################
  ### Radarr - Movie collection manager                                      ###
  ##############################################################################
  # Setup:
  # 1. Configure Root Folder
  #     - Settings > Media Management: Root Folders = [ "/srv/media/movies" ]
  # 2. Add Download Client
  #     - Settings > Download Clients: Add Download Client > qBittorrent
  #         - Host = "127.0.0.1"
  #         - Port = "2111"

  services.radarr.enable = true;
  services.radarr.openFirewall = true;
  services.radarr.group = "media";
  services.radarr.dataDir = "/var/lib/radarr/";
  services.radarr.settings.server.port = 2102;

  services.radarr.environmentFiles = [ config.sops.templates."radarr.env".path ];
  sops.secrets."${radarr_apikey}" = { owner = "radarr"; group = "media"; };
  sops.templates."radarr.env" = {
    content = ''
      RADARR__AUTH__APIKEY=${config.sops.placeholder."${radarr_apikey}"}
      RADARR__AUTH__METHOD=Forms
      RADARR__AUTH__REQUIRED=DisabledForLocalAddresses
    '';
  };

  ##############################################################################
  ### Sonarr - Series collection manager                                     ###
  ##############################################################################
  # Setup:
  # 1. Configure Root Folder
  #     - Settings > Media Management: Root Folders = [ "/srv/media/tvshows" ]

  services.sonarr.enable = true;
  services.sonarr.openFirewall = true;
  services.sonarr.group = "media";
  services.sonarr.dataDir = "/var/lib/sonarr/";
  services.sonarr.settings.server.port = 2103;

  services.sonarr.environmentFiles = [ config.sops.templates."sonarr.env".path ];
  sops.secrets."${sonarr_apikey}" = { owner = "sonarr"; group = "media"; };
  sops.templates."sonarr.env" = {
    content = ''
      SONARR__AUTH__APIKEY=${config.sops.placeholder."${sonarr_apikey}"}
      SONARR__AUTH__METHOD=Forms
      SONARR__AUTH__REQUIRED=DisabledForLocalAddresses
    '';
  };

  ##############################################################################
  ### Bazarr - Manage and download subtitles                                 ###
  ##############################################################################
  # Description:
  #   Companion application to Sonarr and Radarr that manages and downloads   
  #   subtitles based on your requirements.
  # Setup:
  #   1. Languages:
  #       - Languages Filter = [ "English" "Dutch" "Korean" ]
  #       - Languages Profile > Add New Profile
  #           - name = "en ko nl"
  #           - Add Language 3x: "English" "Dutch" "Korean"
  #           - Save
  #       - Default Language Profiles for Newly Added Shows
  #           - Series = true
  #           - Movies = true
  #   2. Providers > Enabled Providers
  #       - Add "OpenSubtitles.com" (see Bitwarden for credentials)
  #       - Add "OpenSubtitles.org"
  #           - Requires VIP membership (16,09 yearly)
  #   3. Subtitles
  #       - > Sub-Zero Subtitle Content Modifications
  #           - "Hearing Impaired" = true
  #           - "Remove Tags" = true
  #           - "OCR Fixes" = true
  #           - "Common Fixes" = true
  #           - "Fix Uppercase" = true
  #       - > Audio Synchronization / Alignment
  #         - "Automatic Subtitles Audio Synchronization" = true
  #         - "Series Score Threshold For Audio Syncs" = 50
  #         - "Movies Score Threshold For Audio Syncs" = 50
  #    4. Sonarr
  #       - Enabled = true, Port = 2103, API Key

  services.bazarr.enable = true;
  services.bazarr.group = "media";
  services.bazarr.openFirewall = true;
  services.bazarr.listenPort = 2107;

  ##############################################################################
  ### Jellyseerr - Media Discovery                                           ###
  ##############################################################################
  # Description:
  #   Integrates Jellyfin with Sonarr and Radarr to let users request media to
  #   be downloaded from Jellyfin.
  #
  # Setup:
  #   1. Walk through first-time setup
  #       1. Setup Jellyfin integration
  #           Jellyfin at "localhost:8096", log in with "jellyfin" user. 
  #       2. Setup Radarr
  #           Set as default server
  #           Server Name "Movies"
  #           Radarr at http://localhost:2102, with apikey from secrets.yaml
  #           Select Quality Profile "2160p Balanced"
  #           Enable Scan
  #       2. Setup Sonarr
  #           Server Name "Series"
  #           Sonarr at http://localhost:2103, with apikey from secrets.yaml
  #           Select Quality Profile "1080p Quality"
  #           Enable Scan
  #       3. Settings
  #           Default Permissions > Manage Requests = "true"
  #           Streaming Region = "Netherlands"

  services.jellyseerr.enable = true;
  services.jellyseerr.port = 2108;
  services.jellyseerr.openFirewall = true;

  ##############################################################################
  ### Profilarr - Configuration manager                                      ###
  ##############################################################################
  # Description:
  #   This service automatically downloads "quality profiles" from a database
  #   and syncs these with instances of sonarr and radarr. The quality profiles
  #   take care of selecting the best (or most fitting) torrent for the desired
  #   quality (1080p, 2160p, ...).

  # Setup:
  # 1. First Time Setup
  #     - on first login, you will be prompted to create a username and password
  # 2. Add Database
  #     - setup the database by adding https://github.com/Dictionarry-Hub/database
  #     - enable autosync on the database
  # 3. Add Radarr
  #     - Name = "Radarr"
  #     - Arr Server = "http://quitlox-pi.local:2102"
  #     - Sync Method = "Scheduled"
  #     - Import as Unique = true
  #     - Sync Internal = "10080" (1 week)
  # 4. Add Sonarr
  #     - Name = "Sonarr"
  #     - Arr Server = "http://quitlox-pi.local:2103"
  #     - Sync Method = "Scheduled"
  #     - Import as Unique = true
  #     - Sync Internal = "10080" (1 week)
  # 5. Media Management
  #     - set "Replace Illegal Characters" to true for both Radarr and Sonarr
  #     - don't forget to hit save on each tab
  #     - hit "Sync All" for both Radarr and Sonarr

  virtualisation.arion.projects = {
    profilarr.settings = {
      project.name = "profilarr";
      services = {
        profilarr = {
          service = {
            image = "santiagosayshey/profilarr:beta";
            container_name = "profilarr";
            ports = [ "2109:6868"];
            volumes = [ "/var/lib/profilarr:/config" ];
            environment = { TZ = "Europe/Amsterdam"; };
            restart = "unless-stopped";
          };
        };
      };
    };
  };

  ##############################################################################
  ### qBittorrent                                                            ###
  ##############################################################################

  # FIXME: work-around due to outdated pkgs (see flake.nix)

  # disable a built-in copy if your base nixpkgs ever gains it
  disabledModules = [ "services/torrent/qbittorrent.nix" ];
  # import the fresh module from nixpkgs-unstable
  imports = [
    "${nixpkgs}/nixos/modules/services/torrent/qbittorrent.nix"
  ];

  networking.firewall.allowedUDPPorts = [ config.services.qbittorrent.torrentingPort ];
  services.qbittorrent.enable = true;
  services.qbittorrent.user = "qbittorrent"; # default
  services.qbittorrent.group = "media";
  services.qbittorrent.profileDir = "/var/lib/qbittorrent";
  services.qbittorrent.torrentingPort = 19279;                # [AirVPN] must be set to remote forwarded port
  services.qbittorrent.webuiPort = 2111;
  services.qbittorrent.openFirewall = true;
  services.qbittorrent.serverConfig = {
    # Configuration recommendations by:
    # https://trash-guides.info/Downloaders/qBittorrent/Basic-Setup/

    LegalNotice.Accepted = true;
    BitTorrent.Session = {
      AddTorrentToTopOfQueue = true;                          # Free to set: newest torrent first
      BTProtocol = "TCP";                                     # Use TCP for performance
      DefaultSavePath = "/srv/media/torrents";
      DisableAutoTMMByDefault = false;                        # Automatic Torrent Management
      DisableAutoTMMTriggers.CategorySavePathChanged = false; # When Category Save Path changed: Relocate affected torrents
      DisableAutoTMMTriggers.DefaultSavePathChanged = false;  # When Default Save Path changed: Relocate affected torrents
      GlobalMaxRatio = 2;                                     # Free to set: seeding ratio
      Interface = "airvpn0";                                  # [AirVPN] as configured below
      InterfaceName = "airvpn0";                              # [AirVPN] as configured below
      InterfaceAddress= "0.0.0.0";                            # [AirVPN] won't work without it
      # GlobalDLSpeedLimit = 85449;                             # 700 Mbps (70% of connection)
      # GlobalUPSpeedLimit = 8545;                              # 70 Mbps (70% of connection)
      Preallocation = true;                                   # Pre-allocate disk space
      uTPRateLimited = false;                                 # [AirVPN] advises to disable rate limiting
    };
    Core = {
      AutoDeleteAddedTorrentFile = "IfAdded";                 # Delete .torrent file after added to qbittorrent
    };
    Network = {
      PortForwardingEnabled = false;                          # Do NOT use UPnP to automatically port forward (security)
    };
    Preferences.WebUI = {
      AuthSubnetWhitelist = "192.168.178.0/24";
      AuthSubnetWhitelistEnabled = true;
      LocalHostAuth = false;
      Username = "qbittorrent";
      # NOTE: if password is forgotten, remove this setting and check the logs for a temporary password
      #     (line must actually be removed from /var/lib/qbittorrent/qBittorrent/config/qBittorrent.conf)
      #     (though password should be necessary due to subnet whitelist)
      Password_PBKDF2 = "@ByteArray(Wt7a55MpU5dvNLTcX1REKQ==:oPdjBY6ldjd8yY+Y3NcUxxBX3DVRJ1nqBPaZntJXmnkb1FyqoyHIVNKNjet07ui5RqdRVhj8LX1oEhWF212nig==)"; # nixos/secrets/secrets.yaml
    };
  };

  ##############################################################################
  ### AirVPN                                                                 ###
  ##############################################################################
  # We use AirVPN as it's cheap and supports static port forwarding
  #     ProtonVPN also supports port-forwarding, but the ports are 
  #     randomly assigned making it (nearly) impossible to declaratively configure.
  #
  # 1. Generate AirVPN Configuration
  #     - Navigate to https://airvpn.org/generator/
  #     - Select "Linux", "WireGuard" and "Europe"
  #     - Hit Generate at the bottom of the page
  # 2. Setup Port Forwarding at AirVPN
  #     - Navigate to https://airvpn.org/ports/
  #     - Add a port (no need to fill in anything, just click plus)
  #         LOCAL PORT MUST ALWAYS CORRESPOND WITH REMOTE PORT (otherwise seeding won't work)
  # 
  # 3. Update configuration of network interface (below)
  #     - All fields can be copied from the generated config
  #     - privatekey and presharedkey must remain secret (stored in nixos/secrets/secrets.yml)
  #     - allowedIPs is overwritten and must correspond with dns
  #         - we don't want to route all traffic (0.0.0.0/0) by default through the VPN for our use-case
  #         - the dns is the most "narrow" range of ips that must use the wireguard interface
  # 4. Configure port forwarding
  #     - `services.qbittorrent.torrentingPort` must be set to the forwarded port


  # Networking: A Quick Intermezzo
  #
  # Goal: route only qbittorrent traffic through VPN tunnel.
  #
  #     Network Tools
  #
  # On a server system like this one, networking is done through
  # `systemd-networkd`. This is a configuration based tool for statically
  # configuring networks and interfaces. It is best used for network
  # configuration that do not change (such as Ethernet of always-on VPN
  # tunnels).
  #
  # On desktop systems, NetworkManager is commonly used instead as it allows
  # for GUI frontend and is better suited for dynamically changing the
  # networking configuration. 
  #
  # On the Pi we use Wifi, so in addition to `systemd-networkd` we have
  # `wpa_supplicant` which is complemenatry as it manages only the wifi
  # interface.
  #
  # It should be noted that these are all *configuration*
  # components. Networking is built into the linux kernel and can be
  # configured manually using some primitive cli tools. The configuration tools
  # exist to automate and persist networking configuration.
  #
  #     systemd-networkd
  #
  # The networkd tools is a simple configuration file based method for
  # statically configuring networking on linux. Networkd configuration is split
  # into (my interpretation):
  #     - links: reconfigure physical interfaces
  #     - netdevs: create virtual interfaces
  #     - networks: network configuration on top of interfaces
  #
  # For our purposes, we need to create a virtual interface and add some
  # networking routes to it.
  #
  #     AllowedIPs
  #
  # I went on a bit of a tangent where I thought that AllowedIPs is the
  # solution, but it is not. We want qbittorrent to route all its traffic
  # (regardless of destination) through the tunnel. Therefore we need to set
  # AllowedIPs to 0.0.0.0/0, the default catch-all. This ensures that any
  # traffic can go into the tunnel.
  #
  #     Note on wg-quick
  #
  # The wg-quick tool/service is provided by the wireguard package and can be
  # used to independently create and configure virtual wireguard network
  # devices. This method therefore does not rely on other networking
  # configuration components such as networkd or NetworkManager.
  #
  # We opt to configure wireguard through networkd, as this is still quite
  # simple and offers more control. By default, wg-quick alters the main table,
  # which is not what we want.
  #
  #     Solution
  #
  # The solution is actually not that hard, and the answer was on the Arch
  # Wiki, though without any explanation. I have since added the explanation to
  # the wiki.
  #
  # Section can be found here:
  # https://wiki.archlinux.org/title/WireGuard#systemd-networkd:_routing_all_traffic_over_WireGuard
  #
  # In short, we let the wireguard interface have its own routing table, and
  # setup policy rules such that traffic from the qbittorrent user is routed
  # through this table.

  sops.secrets."airvpn/privatekey" = { group = "systemd-network"; mode = "0640"; };
  sops.secrets."airvpn/presharedkey" = { group = "systemd-network"; mode = "0640"; };
  networking.firewall.interfaces.airvpn0.allowedTCPPorts = [ 19279 ];
  networking.firewall.checkReversePath = "loose";
  systemd.network = {
    netdevs = {
      # Create the virtual interface
      "50-airvpn0" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "airvpn0";
          MTUBytes = "1320";
        };
        wireguardConfig = {
          PrivateKeyFile = config.sops.secrets."airvpn/privatekey".path;
          # ListenPort = 1637; # default port, do not use random port
          # Mark packets generated by wireguard itself with the tag 0x8888 
          # (mark 0x8888 is meaningless, but commonly used for wireguard)
          FirewallMark = 34952; # 0x8888
        };
        wireguardPeers = [
          {
            PresharedKeyFile = config.sops.secrets."airvpn/presharedkey".path;
            PublicKey = "PyLCXAQT8KkM4T+dUsOQfn+Ub3pGxfGlxkIApuig+hk=";
            AllowedIPs = [ "0.0.0.0/0" "::/0" ];
            Endpoint = "europe3.vpn.airdns.org:1637";
            # Install the AllowedIPs rules to table 1000 *instead of the main table*.
            RouteTable = 1000;
            PersistentKeepalive = 15;
          }
        ];
      };
    };
    networks = {
      # Network configuration for interface
      airvpn0 = {
        matchConfig.Name = "airvpn0"; # configure the airvpn0 virtual interface
        address = [ "10.138.122.183/32" "fd7d:76ee:e68f:a993:4d30:b6dd:fb9:f87a/128" ];
        dns = [ "10.128.0.1" "fd7d:76ee:e68f:a993::1" ];
        routingPolicyRules = [
          {
            FirewallMark = 34952;
            Priority = 10;
            Family = "both";
          }
          # This rule matches traffic originating from the qbittorrent user and
          # routes it through the main (non-vpn) table BUT routing rules in the
          # table with prefix length 0 (default routes like 0.0.0.0/0) are
          # ignored.
          #
          # This makes it so that only for defined "specific" rules the
          # qbittorrent user can use the main table, e.g. for the local subnet.
          {
            User = "qbittorrent";
            SuppressPrefixLength = 0;
            Priority = 30000;
            Family = "both";
          }
          # This rule (with slightly lower priority) matches all traffic
          # originating from the qbittorrent user and routes it through the
          # 1000 table (the wireguard table as defined above).
          #
          # If traffic isn't caught by the previous rule, it is routed through
          # the VPN.
          {
            Table = 1000;
            User = "qbittorrent";
            Priority = 30001;
            Family = "both";
          }
          # Exemptions - Always route through main
          {
            To = "192.168.178.0/24";
            Priority = 5;
          }
        ];
      };
    };
  };

  ###############################################################################
  ### Sync Settings                                                          ###
  ##############################################################################

  ### Sonarr post-start sync unit
  systemd.services."sonarr-settings-sync" = {
    description = "Sync Sonarr settings";
    after = [ "sonarr.service" ];
    wantedBy = [ "sonarr.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        ${script_servarr_settings_sync}/bin/servarr_settings_sync \
          --app sonarr \
          --url "http://127.0.0.1:${toString config.services.sonarr.settings.server.port}" \
          --keyfile "${config.sops.secrets.${sonarr_apikey}.path}"
      '';
    };
  };

  ### Radarr post-start sync unit
  systemd.services."radarr-settings-sync" = {
    description = "Sync Radarr settings";
    after = [ "radarr.service" ];
    wantedBy = [ "radarr.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        ${script_servarr_settings_sync}/bin/servarr_settings_sync \
          --app radarr \
          --url "http://127.0.0.1:${toString config.services.radarr.settings.server.port}" \
          --keyfile "${config.sops.secrets.${radarr_apikey}.path}"
      '';
    };
  };
}

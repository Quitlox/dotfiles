{
  config,
  srvos,
  ...
}:
{
  imports = [
    # system configuration (specific)
    ./hardware-configuration.nix
    ./system/filesystem.nix
    ./system/networking.nix
    # system configuration (general)
    ../../modules/system/nixos-settings.nix
    ../../modules/system/user-quitlox.nix
    ../../modules/service-openssh.nix
    ../../modules/extra-arion.nix
    ../../modules/extra-sops.nix
    ../../modules/bundle-cli.nix
    ../../modules/bundle-chezmoi.nix
    ../../modules/bundle-neovim.nix
    # applications
    ./applications/arion-whoami.nix
    ./applications/media.nix
    ./applications/tailscale.nix
    ./applications/routing.nix
    # server defaults (nice-to-haves) from srvos
    (srvos.outPath + "/nixos/common/detect-hostname-change.nix")
    (srvos.outPath + "/nixos/common/update-diff.nix")
  ];

  quitlox.home.domain = "home.quitlox.dev";
  quitlox.home.lan.ipv4 = "192.168.178.238";
  quitlox.home.lan.subnet = "192.168.178.0/24";
  quitlox.home.dhcp.enable = false;
  quitlox.home.dhcp.interface = "wlan0";
  quitlox.home.dhcp.router = "192.168.178.1";
  quitlox.home.dhcp.range = "192.168.178.100,192.168.178.200,24h";
  quitlox.home.dns.enable = false;
  quitlox.home.dns.public = [ "89.101.251.228" "89.101.251.229" ]; # Ziggo DNS

  # ----- System -----
  networking.hostName = "quitlox-pi";
  time.timeZone = "Europe/Amsterdam";

  system.stateVersion = config.system.nixos.release;
  system.nixos.tags = [ "raspberry-pi-5" config.boot.kernelPackages.kernel.version ];

  # ----- SSL -----
  # Automated SSL certificate process for Hetzner managed domains.
  sops.secrets."hetzner/dns-apikey" = { owner = "traefik"; group = "traefik"; };
  environment.etc."traefik/hetzner.env".text = "HETZNER_API_KEY_FILE=${config.sops.secrets."hetzner/dns-apikey".path}\n";
  services.traefik = {
    environmentFiles = [ "/etc/traefik/hetzner.env" ];
    staticConfigOptions = {
      certificatesResolvers.letsencrypt.acme = {
        email = "kevin.witlox@upcmail.nl";
        storage = "${config.services.traefik.dataDir}/acme.json";
        dnsChallenge.provider = "hetzner";
      };
    };
  };
}

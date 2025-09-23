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
    ../../modules/service-tailscale.nix
    ../../modules/extra-arion.nix
    ../../modules/extra-sops.nix
    ../../modules/bundle-cli.nix
    ../../modules/bundle-chezmoi.nix
    ../../modules/bundle-neovim.nix
    # applications
    ../../modules/extra-dns-home.nix
    # server defaults (nice-to-haves) from srvos
    (srvos.outPath + "/nixos/common/detect-hostname-change.nix")
    (srvos.outPath + "/nixos/common/update-diff.nix")
  ];

  # Configure Pi as DHCP + DNS
  quitlox.home.lan.ipv4 = "192.168.178.3"; # ip of quitlox-pi
  quitlox.home.dhcp.enable = true;
  quitlox.home.dhcp.interface = "end0";
  quitlox.home.dhcp.router = "192.168.178.1";
  quitlox.home.dhcp.range = "192.168.178.100,192.168.178.200,24h";
  quitlox.home.dns.enable = true;
  quitlox.home.dns.public = [ "89.101.251.228" "89.101.251.229" ]; # Ziggo DNS
  quitlox.home.dns.domain.name = "home.quitlox.dev";
  quitlox.home.dns.domain.ipv4 = "192.168.178.2"; # ip of quitlox-homelab

  # ----- System -----
  networking.hostName = "quitlox-pi";
  time.timeZone = "Europe/Amsterdam";

  system.stateVersion = config.system.nixos.release;
  system.nixos.tags = [ "raspberry-pi-5" config.boot.kernelPackages.kernel.version ];
}

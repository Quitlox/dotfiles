{
  config,
  lib,
  srvos,
  ...
}:
{
  imports = [
    # system configuration (specific)
    ./hardware-configuration.nix
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
    ../../hosts/quitlox-pi/applications/media.nix
    ../../hosts/quitlox-pi/applications/routing.nix
    # server defaults (nice-to-haves) from srvos
    (srvos.outPath + "/nixos/common/detect-hostname-change.nix")
    (srvos.outPath + "/nixos/common/update-diff.nix")
  ];

  quitlox.home.domain = "home.quitlox.dev";
  quitlox.home.lan.ipv4 = "192.168.178.2";
  quitlox.home.lan.subnet = "192.168.178.0/24";
  quitlox.home.dhcp.enable = true;
  quitlox.home.dhcp.interface = "enp0s31f6";
  quitlox.home.dhcp.router = "192.168.178.1";
  quitlox.home.dhcp.range = "192.168.178.100,192.168.178.200,24h";
  quitlox.home.dns.enable = true;
  quitlox.home.dns.public = [ "89.101.251.228" "89.101.251.229" ]; # Ziggo DNS

  # ----- System -----
  # Use the systemd-boot EFI boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Performance (/tmp in RAM)
  boot.tmp.useTmpfs = true;

  system.stateVersion = "25.05";
  networking.hostName = "quitlox-homelab";
  time.timeZone = "Europe/Amsterdam";
}

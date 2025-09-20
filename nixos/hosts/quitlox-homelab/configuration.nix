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
    # server defaults (nice-to-haves) from srvos
    (srvos.outPath + "/nixos/common/detect-hostname-change.nix")
    (srvos.outPath + "/nixos/common/update-diff.nix")
  ];

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

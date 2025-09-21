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
    ./applications/media.nix
    # server defaults (nice-to-haves) from srvos
    (srvos.outPath + "/nixos/common/detect-hostname-change.nix")
    (srvos.outPath + "/nixos/common/update-diff.nix")
  ];

  # ----- System -----
  networking.hostName = "quitlox-pi";
  time.timeZone = "Europe/Amsterdam";

  system.stateVersion = config.system.nixos.release;
  system.nixos.tags = [ "raspberry-pi-5" config.boot.kernelPackages.kernel.version ];
}

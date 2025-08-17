{
  lib,
  config,
  pkgs,
  srvos,
  ...
}:
{
  imports = [
    ./hardware/configuration.nix
    ./system/filesystem.nix
    ./system/networking.nix
    ./system/user.nix
    ../../modules/sops.nix
    ../../modules/openssh.nix
    ../../modules/bundle-cli.nix
    # Some nice-to-haves from srvos
    (srvos.outPath + "/nixos/common/detect-hostname-change.nix")
    (srvos.outPath + "/nixos/common/update-diff.nix")
  ];

  # ----- System -----
  networking.hostName = "quitlox-pi";
  time.timeZone = "UTC"; # Locale

  # ----- Nix -----
  nix.settings.trusted-users = [ "@wheel" ];
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  system.stateVersion = config.system.nixos.release;
  system.nixos.tags = [
    "raspberry-pi-5"
    config.boot.kernelPackages.kernel.version
  ];

  # Disable nix channels. Use flakes instead.
  nix.channel.enable = false;
  # Fallback quickly if substituters are not available.
  nix.settings.connect-timeout = 5;
  nix.settings.fallback = true;

  # The default at 10 is rarely enough.
  nix.settings.log-lines = lib.mkDefault 25;

  # Avoid disk full issues
  nix.settings.max-free = lib.mkDefault (3000 * 1024 * 1024);
  nix.settings.min-free = lib.mkDefault (512 * 1024 * 1024);

  # Avoid copying unnecessary stuff over SSH
  nix.settings.builders-use-substitutes = true;
}

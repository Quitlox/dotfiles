{
  lib,
  config,
  pkgs,
  srvos,
  ...
}:
{
  imports = [
    # system configuration
    ./hardware/configuration.nix
    ./system/filesystem.nix
    ./system/networking.nix
    ./system/nixos.nix
    ./system/virtualization.nix
    ./system/user.nix
    ../../modules/sops.nix
    ../../modules/openssh.nix
    ../../modules/bundle-cli.nix
    ../../modules/bundle-chezmoi.nix
    ../../modules/bundle-neovim.nix
    # applications
    ./applications/arion-whoami.nix
    ./applications/media.nix
    ./applications/tailscale.nix
    ./applications/traefik.nix
    # server defaults (nice-to-haves) from srvos
    (srvos.outPath + "/nixos/common/detect-hostname-change.nix")
    (srvos.outPath + "/nixos/common/update-diff.nix")
  ];

  # ----- System -----
  networking.hostName = "quitlox-pi";
  time.timeZone = "Europe/Amsterdam";
}

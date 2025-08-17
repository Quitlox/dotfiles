{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware/configuration.nix
    ./filesystem.nix
    ./networking.nix
    ./user.nix
    ../../modules/sops.nix
    ../../modules/openssh.nix
  ];

  environment.systemPackages = with pkgs; [
    tree
    curl
    wget
    git
    vim
    neovim
  ];

  # ----- System -----
  networking.hostName = "quitlox-pi";
  time.timeZone = "UTC"; # Locale

  # Nix
  nix.settings.trusted-users = [ "quitlox" ];
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  system.stateVersion = config.system.nixos.release;
  system.nixos.tags = [
    "raspberry-pi-5"
    config.boot.kernelPackages.kernel.version
  ];
}

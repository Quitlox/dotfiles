{ config, lib, ... }: 
{
  nix.settings.trusted-users = [ "@wheel" ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
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

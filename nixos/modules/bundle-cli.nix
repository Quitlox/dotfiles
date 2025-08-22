
{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;
  cfg = config.bundles.cli;
in
{
  options.bundles.cli = {
    enable = mkEnableOption "bundle: cli" // {
      default = true;
    };
  };

  config = mkIf cfg.enable {
    # Install packages
    environment.systemPackages = with pkgs; [
      tree
      curl
      wget
      git
      vim
      kitty.terminfo
      fd
    ];
  };
}

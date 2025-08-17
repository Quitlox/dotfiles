
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
    mkDefault
    ;
  cfg = config.bundles.cli;
in
{
  options.bundles.cli = {
    enable = mkEnableOption "bundle: cli";
  };

  config = mkIf cfg.enable {
    # Install packages
    environment.systemPackages = with pkgs; [
      tree
      curl
      wget
      git
      vim
      neovim
    ];
  };
}

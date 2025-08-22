
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
    enable = mkEnableOption "bundle: cli" // {
      default = true;
    };
  };

  config = mkIf cfg.enable {
    # Neovim
    programs.neovim.enable = true;
    programs.neovim.defaultEditor = true;

    # Install packages
    environment.systemPackages = with pkgs; [
      tree
      curl
      wget
      git
      vim
      kitty.terminfo
    ];
  };
}

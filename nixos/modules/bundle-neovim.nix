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
  cfg = config.bundles.neovim;
in
{
  options.bundles.neovim = {
    enable = mkEnableOption "bundle: neovim" // {
      default = true;
    };
  };

  config = mkIf cfg.enable {
    # Neovim
    programs.neovim.enable = true;
    programs.neovim.defaultEditor = true;

    # Configuration Dependencies
    environment.systemPackages = with pkgs; [ 
            gcc 
            tree-sitter 
            rustc
            cargo 
            lua51Packages.lua 
            lua51Packages.luarocks 
            lua51Packages.rocks-nvim 
            unzip # for installing tree-sitter parsers
        ];
  };
}

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
  cfg = config.bundles.chezmoi;
in
{
  options.bundles.chezmoi = {
    enable = mkEnableOption "bundle: chezmoi" // {
      default = true;
    };
  };

  config = mkIf cfg.enable {
    # Ensure GnuPG agent is running and has a pinentry
    programs.gnupg.agent.enable = mkDefault true;
    programs.gnupg.agent.pinentryPackage = mkDefault pkgs.pinentry-curses;

    # Install packages
    environment.systemPackages = with pkgs; [
      chezmoi
      rbw
      gnupg
      pinentry-curses
    ];
  };
}

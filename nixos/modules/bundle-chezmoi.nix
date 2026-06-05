# Chezmoi
#
# --- Setup on new installation ---
#   - `rbw login`
#   - `chezmoi init quitlox --apply`
#   - `cd ~/.local/share/chezmoi`
#   - `git remote set-url origin git@github.com:Quitlox/dotfiles.git`
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

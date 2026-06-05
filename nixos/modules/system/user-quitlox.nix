{
  users.users.quitlox = {
    isNormalUser = true;
    initialHashedPassword = "";
    extraGroups = [
      "wheel"
      "media"
      "opencode"
    ];
  };

  # Security
  # Don't require sudo/root to `reboot` or `poweroff`.
  security.polkit.enable = true;
}

{
  # User
  users.users.quitlox = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  # First time login
  # Allow the user to log in as root without a passwd.
  users.users.root.initialHashedPassword = "";
  users.users.quitlox.initialHashedPassword = "";

  # Security
  # Don't require sudo/root to `reboot` or `poweroff`.
  security.polkit.enable = true;

  users.users.quitlox.openssh.authorizedKeys.keys = [
    # YOUR SSH PUB KEY HERE #
  ];
}

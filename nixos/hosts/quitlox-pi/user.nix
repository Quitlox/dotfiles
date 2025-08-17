{
  # User
  users.users.quitlox = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    # Allow the graphical user to login without password
    initialHashedPassword = "";
  };

  # Security
  # Allow the user to log in as root without a passwd.
  users.users.root.initialHashedPassword = "";
  # Don't require sudo/root to `reboot` or `poweroff`.
  security.polkit.enable = true;

  # Locale
  time.timeZone = "UTC";

  # SSH
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  users.users.quitlox.openssh.authorizedKeys.keys = [
    # YOUR SSH PUB KEY HERE #
  ];
}

{
  pkgs,
  ...
}:
{
  # Configuration
  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    
    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ]; # Used on [ quitlox-pi ]
    };
  };

  # Installation
  environment.systemPackages = with pkgs; [
    sops
    age
  ];
}

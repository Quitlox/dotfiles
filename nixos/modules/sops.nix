{
  config,
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

    # Secrets
    secrets = {
      pass-wifi = {
        mode = "0400";
        owner = "root";
        group = "root";
      };
    };

    # Templates for secrets that need specific formats
    templates."wifi" = {
      content = ''
        psk_wifi_home=${config.sops.placeholder.pass-wifi}
      '';
      mode = "0400";
      owner = "root";
      group = "root";
    };
  };

  # Installation
  environment.systemPackages = with pkgs; [
    sops
    age
  ];
}

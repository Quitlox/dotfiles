# SOPS
#
# SOPS (Secrets OPerationS) is used to store secrets for use in NixOS configuration.
# The secrets are stored in encrypted form in the doftiles repository in /nixos/secrets
#
# To edit the secrets:
#     > `sops nixos/secrets/secrets.yaml`
#
# If the SSH key of the machine is not onboarded, use the personal private key:
#     > `export SOPS_AGE_KEY_FILE=~/.ssh/.age_private_key.txt`
#
# Currently onboarded keys:
# - quitlox-pi "/etc/ssh/ssh_host_ed25519_key"
# - .age_private_key.txt

{
  pkgs,
  sops-nix,
  ...
}:
{
  imports = [
    sops-nix.nixosModules.sops
  ];

  # Configuration
  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.age.sshKeyPaths = [ 
    "/etc/ssh/ssh_host_ed25519_key" # Used on [ quitlox-pi ]
  ]; 

  # Installation
  environment.systemPackages = with pkgs; [
    sops
    age
  ];
}

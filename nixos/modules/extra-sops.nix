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
# To onboard a new host:
#     > nix-shell -p ssh-to-age --run 'cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age'
#     > add to `.sops.yaml` in dotfiles
#     > `sops updatekeys nixos/secrets/secrets.yaml`

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
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ]; 

  # Installation
  environment.systemPackages = with pkgs; [
    sops
    age
  ];
}

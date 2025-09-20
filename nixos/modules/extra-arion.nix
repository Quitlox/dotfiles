{ pkgs, arion, ... }:
{
  imports = [
    arion.nixosModules.arion
  ];

  environment.systemPackages = [ pkgs.arion ];
  virtualisation.docker.enable = true;
  virtualisation.arion.backend = "docker";
}

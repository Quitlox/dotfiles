# Arion
#
# Arion is a tool for building and running applications that consist of
# multiple docker containers using NixOS modules. It has special support for
# docker images that are built with Nix, for a smooth development experience
# and improved performance.
{ pkgs, arion, ... }:
{
  imports = [
    arion.nixosModules.arion
  ];

  environment.systemPackages = [ pkgs.arion ];
  virtualisation.docker.enable = true;
  virtualisation.arion.backend = "docker";

  # Default all containers to log to the systemd journal instead of json-file.
  # View with e.g. `journalctl CONTAINER_NAME=profilarr` or `journalctl -t profilarr`.
  virtualisation.docker.daemon.settings = {
    log-driver = "journald";
    log-opts.tag = "{{.Name}}";
  };
}

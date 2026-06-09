# Glance extension - OpenCode Activity widget
#
# Builds the Go extension as a Docker image and runs it as a sidecar
# in the glance arion project.
{ config, lib, pkgs, ... }:
let
  opencode-extension-bin = pkgs.buildGoModule {
    pname = "opencode-glance-extension";
    version = "0.1.0";
    src = ./glance/extension;
    vendorHash = "";
    ldflags = [ "-s" "-w" ];
    CGO_ENABLED = 0;
  };

  opencode-extension-image = pkgs.dockerTools.buildImage {
    name = "opencode-glance-extension";
    tag = "latest";
    config = {
      Cmd = [ "/bin/opencode-glance-extension" ];
      ExposedPorts = { "8080/tcp" = {}; };
      Env = [ "SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt" ];
    };
    copyToRoot = [ opencode-extension-bin pkgs.cacert ];
  };
in
{
  # Load the opencode-extension Docker image before arion starts
  systemd.services.docker-load-opencode-extension = {
    description = "Load opencode-glance-extension Docker image";
    wantedBy = [ "multi-user.target" ];
    after = [ "docker.service" ];
    requires = [ "docker.service" ];
    before = [ "arion-glance.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.docker}/bin/docker load -i ${opencode-extension-image}";
      RemainAfterExit = true;
    };
  };

  virtualisation.arion.projects.glance.settings = {
    services.opencode-extension.service = {
      image = "opencode-glance-extension:latest";
      container_name = "opencode-extension";
      restart = "unless-stopped";
      networks = [ "proxy" ];
      env_file = [ config.sops.templates."glance.env".path ];
      environment = {
        OPENCODE_BASE_URL = "https://opencode.home.quitlox.dev";
        PORT = "8080";
      };
      labels = {
        "traefik.enable" = "false";
      };
    };
  };
}
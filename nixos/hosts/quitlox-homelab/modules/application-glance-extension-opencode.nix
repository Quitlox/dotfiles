# Glance Extension - OpenCode Activity Widget
#
# A Widget showing the recent OpenCode sessions and projects.
#
# Builds the Go extension as a Docker image and runs it as a sidecar in the
# glance arion project.
{ config, lib, pkgs, ... }:
let
  glance-extension-opencode-bin = pkgs.buildGoModule {
    pname = "glance-extension-opencode";
    version = "0.1.0";
    src = ./glance/extension-opencode;
    vendorHash = null;
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = "0";
  };

  glance-extension-opencode-image = pkgs.dockerTools.buildImage {
    name = "glance-extension-opencode";
    tag = "latest";
    config = {
      Cmd = [ "/bin/glance-extension-opencode" ];
      ExposedPorts = { "8080/tcp" = {}; };
      # SSL Certificates required to perform HTTPS
      Env = [ "SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt" ];
    };
    copyToRoot = [ glance-extension-opencode-bin pkgs.cacert ];
  };
in
{
  # Load the opencode-extension Docker image before arion starts
  systemd.services.docker-load-glance-extension-opencode = {
    description = "Load glance-extension-opencode Docker image";
    wantedBy = [ "multi-user.target" ];
    after = [ "docker.service" ];
    requires = [ "docker.service" ];
    before = [ "arion-glance.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.docker}/bin/docker load -i ${glance-extension-opencode-image}";
      RemainAfterExit = true;
    };
  };

  # Add the image as a sidecar to the glance container
  virtualisation.arion.projects.glance.settings = {
    services.glance-extension-opencode.service = {
      image = "glance-extension-opencode:latest";
      container_name = "glance-extension-opencode";
      restart = "unless-stopped";
      networks = [ "proxy" ];
      extra_hosts = [ "host.docker.internal:host-gateway" ];
      env_file = [ config.sops.templates."glance.env".path ];
      environment = {
        OPENCODE_BASE_URL = "http://host.docker.internal:4096";
        OPENCODE_EXTERNAL_URL = "https://opencode.home.quitlox.dev";
        PORT = "8080";
      };
      labels = {
        "traefik.enable" = "false";
      };
    };
  };
}

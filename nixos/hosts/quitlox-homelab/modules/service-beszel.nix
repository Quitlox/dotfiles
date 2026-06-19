# Beszel
#
# Beszel is a lightweight server monitoring platform that includes Docker
# statistics, historical data, and alert functions.
#
# --- Deployment ---
#
# An agent is deployed via Docker on the *host* network (as it needs to access
# other services). The Agent listens on port 45876.
#
# A Hub (with Web UI) is deployed and exposed under:
# - http://quitlox-homelab.local:4001
# - https://beszel.home.quitlox.dev
#
# --- Configuration ---
#
# Agents can be connected through the hub in two ways: using SSH (and an SSH
# key, initiated by hub) and using WebSockets (using a TOKEN, initiated by
# agent).
#
# Both the secrets for the SSH method (`services.beszel.ssh_priv`) and the
# WebSocket method (`services.beszel.token`) have been provisioned, as
# otherwise the service generates its own which would hinder future declarative
# configuration.
#
# Since the agent and the hub run on the same machine, we use a local socket
# `/beszel/socket` and SSH.
#
{ config, ... }:
let
  domain = config.quitlox.traefik.domain;

  # Unprivileged user for the container
  beszelUID = 1504;
  beszelGID = 1504;
in
{
  systemd.tmpfiles.rules = [
    "d /var/lib/beszel/ 0700 beszel beszel - -"
    "d /var/lib/beszel/data/ 0700 beszel beszel - -"
    "d /var/lib/beszel/socket/ 0700 beszel beszel - -"
    "d /var/lib/beszel/agent-data/ 0700 beszel beszel - -"
  ];

  # --- Unprivileged user ---
  users.groups.beszel.gid = beszelGID;
  users.users.beszel = {
    uid = beszelUID;
    home = "/var/lib/beszel";
    group = "beszel";
    isSystemUser = true;
  };

  ##############################################################################
  ### Secrets ###
  ##############################################################################

  sops.secrets."services/beszel/ssh_priv" = {
    owner = "beszel";
    mode = "0600";
  };
  sops.secrets."services/beszel/ssh_pub" = {
    owner = "beszel";
  };
  sops.secrets."services/beszel/agent-token" = {
    owner = "beszel";
  };
  sops.secrets."services/beszel/user_name" = {
    owner = "beszel";
  };
  sops.secrets."services/beszel/user_pass" = {
    owner = "beszel";
  };

  # `hub.env` - provision first user
  sops.templates."beszel-hub.env" = {
    owner = "beszel";
    content = ''
      USER_EMAIL=${config.sops.placeholder."services/beszel/user_name"}
      USER_PASSWORD=${config.sops.placeholder."services/beszel/user_pass"}
    '';
  };

  # Hub: `config.yml` (registered agents)
  # Token isn't used, but otherwise automatically generated
  sops.templates."beszel-config.yml" = {
    owner = "beszel";
    content = ''
      systems:
        - name: "quitlox-homelab"
          host: "/beszel_socket/beszel.sock"
          token: "${config.sops.placeholder."services/beszel/agent-token"}"
          users:
            - "${config.sops.placeholder."services/beszel/user_name"}"
    '';
  };

  ##############################################################################
  ### Docker Services                                                        ###
  ##############################################################################

  virtualisation.arion.projects.beszel.settings = {
    project.name = "beszel";
    networks.proxy.name = "proxy";

    # --- Service: Beszel (Web) ---
    services.beszel.service = {
      image = "henrygd/beszel:latest";
      container_name = "beszel";
      restart = "unless-stopped";
      env_file = [ config.sops.templates."beszel-hub.env".path ];
      environment = {
        APP_URL = "https://beszel.${domain}";
      };
      ports = [
        "4001:8090"
      ];
      volumes = [
        "/var/lib/beszel/data:/beszel_data"
        "/var/lib/beszel/socket:/beszel_socket"
        # Hub identity
        "${config.sops.secrets."services/beszel/ssh_priv".path}:/beszel_data/id_ed25519:ro"
        # Declarative system config
        "${config.sops.templates."beszel-config.yml".path}:/beszel_data/config.yml:ro"
      ];
      labels = {
        "traefik.enable" = "true";

        # Web UI: https://beszel.home.quitlox.dev/
        "traefik.http.routers.beszel.rule" = "Host(`beszel.${domain}`)";
        "traefik.http.routers.beszel.middlewares" = "ip-internal@file";
        "traefik.http.routers.beszel.service" = "beszel";
        "traefik.http.services.beszel.loadbalancer.server.port" = "8090";
      };
    };

    # --- Service: Beszel (Agent) ---
    services.beszel-agent.service = {
      image = "henrygd/beszel-agent:alpine";
      container_name = "beszel-agent";
      restart = "unless-stopped";
      network_mode = "host";
      environment = {
        LISTEN = "/beszel_socket/beszel.sock";
        KEY_FILE = "/run/secrets/beszel_key";
      };
      volumes = [
        "/var/lib/beszel/agent-data:/var/lib/beszel-agent"
        # Socket for communication with hub
        "/var/lib/beszel/socket:/beszel_socket"
        # Public key of Hub for authentication
        "${config.sops.secrets."services/beszel/ssh_pub".path}:/run/secrets/beszel_key:ro"
        # Monitoring: Docker 
        "/var/run/docker.sock:/var/run/docker.sock:ro"
        # Monitoring: Systemd
        "/var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket"
      ];
      # Monitoring: S.M.A.R.T. drive monitoring
      devices = [
        # FIXME: Would be great to "automate" this
        "/dev/nvme0n1:/dev/nvme0"
        "/dev/sda:/dev/sda"
        "/dev/sdb:/dev/sdb"
      ];
      # Monitoring: S.M.A.R.T. drive monitoring
      capabilities = {
        SYS_RAWIO = true;
        SYS_ADMIN = true;
      };
    };
  };

  ##############################################################################
  ### Docker Healthchecks                                                    ###
  ##############################################################################

  virtualisation.arion.projects.beszel.settings.services.beszel.service.healthcheck = {
    test = [
      "CMD"
      "/beszel"
      "health"
      "--url"
      "http://localhost:8090"
    ];
    interval = "120s";
    start_period = "10s";
    timeout = "5s";
  };

  virtualisation.arion.projects.beszel.settings.services.beszel-agent.service.healthcheck = {
    test = [
      "CMD"
      "/agent"
      "health"
    ];
    interval = "120s";
  };

}

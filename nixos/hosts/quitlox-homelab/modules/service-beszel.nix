# Beszel
#
# Beszel is a lightweight server monitoring platform that includes Docker
# statistics, historical data, and alert functions.
#
# --- Deployment ---
#
# An agent is deployed via docker on the *host* network (as it needs to access
# other services). The Agent listens on port 45876.
#
# A Hub (with Web UI) is deployed and exposed under:
# - http://localhost:8090
# - https://beszel.home.quitlox.dev
#
# --- Configuration ---
#
# Through environment variables and a `config.yml`, the agent is automatically
# registered to the hub. The hub has a SSH key pair and the public key is
# shared with the agent. This ensures the agent can authenticate the
# hub. A TOKEN is also provided to the agent environment and declared in the
# Hub's `config.yml`, registering the agent to the hub.
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
  sops.secrets."services/beszel/token" = {
    owner = "beszel";
  };
  sops.secrets."services/beszel/user_name" = {
    owner = "beszel";
  };
  sops.secrets."services/beszel/user_pass" = {
    owner = "beszel";
  };

  # `hub.env`
  sops.templates."beszel-hub.env" = {
    owner = "beszel";
    content = ''
      USER_EMAIL=${config.sops.placeholder."services/beszel/user_name"}
      USER_PASSWORD=${config.sops.placeholder."services/beszel/user_pass"}
    '';
  };

  # `beszel-agent.env`
  sops.templates."beszel-agent.env" = {
    owner = "beszel";
    content = ''
      KEY=${config.sops.placeholder."services/beszel/ssh_pub"}
      TOKEN=${config.sops.placeholder."services/beszel/token"}
    '';
  };

  # Hub: `config.yml` (register agent)
  sops.templates."beszel-config.yml" = {
    owner = "beszel";
    content = ''
      systems:
      - name: "quitlox-homelab"
      host: "/beszel_socket/beszel.sock"
      token: "${config.sops.placeholder."services/beszel/token"}"
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
      environment = {
        APP_URL = "https://beszel.${domain}";
      };
      ports = [
        "8090:8090"
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
        "traefik.enable" = true;

        # Web UI: https://beszel.home.quitlox.dev/
        "traefik.http.routers.beszel.rule" = "Host(`beszel.${domain}`)";
        "traefik.http.routers.beszel.middlewares" = "ip-internal@file";
        "traefik.http.routers.beszel.service" = "beszel";
      };
    };

    # --- Service: Beszel (Agent) ---
    services.beszel-agent.service = {
      image = "henrygd/beszel-agent:latest";
      container_name = "beszel-agent";
      restart = "unless-stopped";
      network_mode = "host";
      volumes = [
        "/var/lib/beszel/agent-data:/var/lib/beszel-agent"
        "/var/lib/beszel/socket:/beszel_socket"
        "/var/run/docker.sock:/var/run/docker.sock:ro"
        # Secrets
        "${config.sops.secrets."services/beszel/ssh_pub".path}:/run/secrets/beszel_key:ro"
        "${config.sops.secrets."services/beszel/token".path}:/run/secrets/beszel_token:ro"
      ];
      environment = {
        LISTEN = "/beszel_socket/beszel.sock";
        # FIXME: How do I "protect" this endpoint? Should only be reachable from localhost
        HUB_URL = "http://localhost:8090";
        TOKEN_FILE = "/run/secrets/beszel_key";
        KEY_FILE = "/run/secrets/beszel_token";
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

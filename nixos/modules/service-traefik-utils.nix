# Traefik - Utilities
#
# Convenience options layered on top of the base traefik setup in
# `service-traefik.nix`. Provides `quitlox.traefik.expose-internal`, a shorthand
# for exposing a local service on `<name>.<domain>` behind `ip-internal`.
#
{ config, lib, ... }:
let
  cfg = config.quitlox.traefik;
in
{
  ##############################################################################
  ### variables                                                              ###
  ##############################################################################

  options.quitlox.traefik = {
    expose-internal = lib.mkOption {
      default = { };
      description = ''
        Easily expose a service running on a particular port to
        `<name>.<domain>`, restricted using the `ip-internal` middleware.
      '';
      example = lib.literalExpression ''
        { jellyfin.port = 8096; radarr.port = 2102; }
      '';
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, ... }:
          {
            options = {
              port = lib.mkOption {
                type = lib.types.port;
                description = "Local port the service listens on.";
              };
              host = lib.mkOption {
                type = lib.types.str;
                default = "127.0.0.1";
                description = "Hostname the service listens on.";
              };
              subdomain = lib.mkOption {
                type = lib.types.str;
                default = name;
                description = "Subdomain to expose the service under.";
              };
              middlewares = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ "ip-internal" ];
                description = "Traefik middlewares to apply.";
              };
            };
          }
        )
      );
    };
  };

  ##############################################################################
  ### configuration                                                          ###
  ##############################################################################

  config = {
    services.traefik.dynamicConfigOptions.http = {
      services = lib.mapAttrs (name: svc: {
        loadBalancer.servers = [ { url = "http://${svc.host}:${toString svc.port}"; } ];
      }) cfg.expose-internal;

      routers = lib.mapAttrs (name: svc: {
        inherit (svc) middlewares;
        entryPoints = [ "websecure" ];
        rule = "Host(`${svc.subdomain}.${cfg.domain}`)";
        service = name;
      }) cfg.expose-internal;
    };
  };
}

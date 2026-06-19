# Home Assistant - Command: Update and Rebuild
#
# We setup a systemd unit triggerable by Home Assistant to launch the update and rebuild command.
#
#   - HA writes a trigger file  -> /bridge/rebuild.trigger
#   - a systemd.path watches it -> starts homeassistant-command-rebuild.service (root)
#   - the service writes phase  -> /bridge/rebuild.status  (polled by HA sensor)
#   - the service writes output -> /bridge/rebuild.log     (shown in HA + journald)
#
{ pkgs, ... }:
let
  bridgeDir = "/var/lib/homeassistant/bridge";

  homeassistant-command-rebuild = pkgs.writeShellScriptBin "homeassistant-command-rebuild" ''
    set -euo pipefail

    BRIDGE="${bridgeDir}"
    LOG="$BRIDGE/rebuild.log"
    STATUS="$BRIDGE/rebuild.status"

    status() { echo "$1" > "$STATUS"; }

    # Output to log file and journald (through stdout/stderr)
    : > "$LOG"
    exec > >(tee -a "$LOG") 2>&1

    on_error() {
      code=$?
      status "failed:$code"
      echo "homeassistant-command-rebuild FAILED (exit $code)"
      exit "$code"
    }
    trap on_error ERR

    status "running:flake-update"
    echo "==> nix flake update --flake /etc/nixos"
    nix flake update --flake /etc/nixos

    status "running:rebuild"
    echo "==> nixos-rebuild switch --flake /etc/nixos"
    nixos-rebuild switch --flake /etc/nixos

    status "success"
    echo "homeassistant-command-rebuild SUCCESS"
  '';
in
{
  environment.systemPackages = [ homeassistant-command-rebuild ];

  systemd.services.homeassistant-command-rebuild = {
    description = "Oneshot systemd unit that performs a nixos update and rebuild, to be used in Home Assistant.";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${homeassistant-command-rebuild}/bin/homeassistant-command-rebuild";
      TimeoutStartSec = "3600";
    };
    path = [ pkgs.nix pkgs.git "/run/current-system/sw" ];
  };

  systemd.paths.homeassistant-command-rebuild = {
    description = "Watch file to trigger homeassistant-command-rebuild";
    wantedBy = [ "multi-user.target" ];
    pathConfig = {
      PathModified = "${bridgeDir}/rebuild.trigger";
      Unit = "homeassistant-command-rebuild.service";
    };
  };
}

# Home Assistant - Command: Reboot
#
# Reboot server command for homeassistant. M
# Mirrors application-homeassistant-command-rebuild.nix.
#
#   - HA writes a trigger file  -> /bridge/reboot.trigger
#   - a systemd.path watches it -> starts homeassistant-command-reboot.service (root)
#   - the service writes phase  -> /bridge/reboot.status   (polled by HA sensor)
#   - the service execs         -> systemctl reboot        (HA goes down here)
#   - on next boot a mark-complete unit flips status       -> /bridge/reboot.status = "success"
#     (ordered before arion-homeassistant.service so HA reads "success" on startup)
#
{ pkgs, config, ... }:
let
  bridgeDir = "/var/lib/homeassistant/bridge";

  homeassistant-command-reboot = pkgs.writeShellScriptBin "homeassistant-command-reboot" ''
    set -euo pipefail

    STATUS="${bridgeDir}/reboot.status"
    echo "rebooting" > "$STATUS"
    exec systemctl reboot
  '';

  homeassistant-command-reboot-mark-complete = pkgs.writeShellScriptBin "homeassistant-command-reboot-mark-complete" ''
    set -euo pipefail
    STATUS="${bridgeDir}/reboot.status"
    if [ -f "$STATUS" ] && [ "$(cat "$STATUS")" = "rebooting" ]; then
      echo "success" > "$STATUS"
    fi
  '';
in
{
  environment.systemPackages = [
    homeassistant-command-reboot
    homeassistant-command-reboot-mark-complete
  ];

  systemd.services.homeassistant-command-reboot = {
    description = "Oneshot systemd unit that reboots the server, triggered from Home Assistant.";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${homeassistant-command-reboot}/bin/homeassistant-command-reboot";
    };
  };

  systemd.paths.homeassistant-command-reboot = {
    description = "Watch file to trigger homeassistant-command-reboot";
    wantedBy = [ "multi-user.target" ];
    pathConfig = {
      PathModified = "${bridgeDir}/reboot.trigger";
      Unit = "homeassistant-command-reboot.service";
    };
  };

  # After a HA-triggered reboot, flip the status file from "rebooting" to
  # "success" on next boot, before HA starts so its sensor reads "success".
  systemd.services.homeassistant-command-reboot-mark-complete = {
    description = "Mark /bridge/reboot.status as success after a triggered reboot.";
    wantedBy = [ "multi-user.target" ];
    before = [ "arion-homeassistant.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${homeassistant-command-reboot-mark-complete}/bin/homeassistant-command-reboot-mark-complete";
      RemainAfterExit = true;
    };
  };
}
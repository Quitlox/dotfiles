#!/bin/sh

reload_eww_bar() {
    # Reload the eww bar
    sh ~/.config/hypr/scripts/launch_eww_bar.sh
}

handle() {
    case $1 in 
        monitoradded*)
            hyprctl dispatch moveworkspacetomonitor "2 1"
            hyprctl dispatch moveworkspacetomonitor "3 1"
            hyprctl dispatch moveworkspacetomonitor "4 1"
            hyprctl dispatch moveworkspacetomonitor "5 1"
            hyprctl dispatch moveworkspacetomonitor "6 1"
            hyprctl dispatch moveworkspacetomonitor "7 1"
            hyprctl dispatch moveworkspacetomonitor "8 1"
            hyprctl dispatch moveworkspacetomonitor "9 1"
            
            # Reload eww bar when a monitor is added
            reload_eww_bar
            ;;
        monitorremoved*)
            # Check if only one monitor remains and it's disabled
            # If so, re-enable the built-in monitor (eDP-1)
            if [ "$(hyprctl monitors | grep -c "Monitor")" -eq 0 ]; then
                hyprctl keyword monitor eDP-1,preferred,auto,1
            fi
            
            # Reload eww bar when a monitor is removed
            reload_eww_bar
            ;;
    esac
}

socat - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock" | while read -r line; do handle "$line"; done

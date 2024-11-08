#!/usr/bin/env bash

monitor=$1

hyprctl monitors -j | jq '.[] | select(.name=="${monitor}") | .activeWorkspace.id'

socat -u UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - |
  stdbuf -o0 awk -F '>>|,' -e '/^workspace>>/ {print $2}' -e '/^focusedmon>>/ {print $3}'

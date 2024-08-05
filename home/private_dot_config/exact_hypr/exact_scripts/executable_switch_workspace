#!/bin/sh

selected_workspace=$1
curr_workspace=$(hyprctl activeworkspace | awk -F\  '{print $3; exit}')

if [ $selected_workspace -eq $curr_workspace ]; then
    hyprctl dispatch "workspace previous"
else
    hyprctl dispatch "workspace $selected_workspace"
fi

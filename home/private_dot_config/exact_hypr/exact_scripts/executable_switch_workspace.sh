#!/bin/sh

# This script manages workspace switching in the Hyprland environment.
# It aims to handle transitions between workspaces and enables toggling
# to the most recently active workspace.
#
# It maintains only the last previous workspace.

history_file="/tmp/workspace_history"

# Ensure history file exists even if it's empty
touch $history_file

selected_workspace=$1
curr_workspace=$(hyprctl activeworkspace | awk -F\  '{print $3; exit}')

# Only update if the current workspace changes
if [ "$selected_workspace" -ne "$curr_workspace" ]; then
    # Log the current workspace to history before the switch
    echo "$curr_workspace" >$history_file
    hyprctl dispatch "workspace $selected_workspace"
else
    # Switching to current: use the recorded previous
    if [ -s $history_file ]; then
        previous_workspace=$(cat $history_file)
        hyprctl dispatch "workspace $previous_workspace"

        # After toggling, update the history with the workspace that becomes previous
        echo "$curr_workspace" >$history_file
    fi
fi

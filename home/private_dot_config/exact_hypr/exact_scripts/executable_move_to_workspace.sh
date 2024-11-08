#!/bin/sh

# This script handles moving windows to different workspaces in the Hyprland environment.
# It maintains only the most recent previous workspace.
#
# When moving a window to the current workspace, it automatically relocates it to
# the last recorded previous workspace instead, if there is one.

history_file="/tmp/workspace_history"

# Ensure history file exists
touch $history_file

destination_workspace=$1
current_workspace=$(hyprctl activeworkspace | awk -F\  '{print $3; exit}')

# Determine the actual workspace to move to
if [ "$destination_workspace" -eq "$current_workspace" ] && [ -s $history_file ]; then
    # Fetch the previous workspace from history
    destination_workspace=$(cat $history_file)
fi

# Perform the move operation
hyprctl dispatch "movetoworkspace $destination_workspace"

# Update history if moving to a different workspace than the current one
if [ "$destination_workspace" -ne "$current_workspace" ]; then
    echo "$current_workspace" >$history_file
fi

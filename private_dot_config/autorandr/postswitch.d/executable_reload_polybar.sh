#!/usr/bin/env sh

source "$(chezmoi source-path)/private_dot_config/dotfiles/include/dep_all.sh"

binformation "Running script: \"reload_polybar.sh\""

# Restart polybars
sh $HOME/.config/polybar/new_multi_launch.sh

#! /bin/bash

set -o errexit
set -o nounset

########################################
### Wallpaper                        ###
########################################

feh --bg-scale ./wallpaper

########################################
### Colorscheme                      ###
########################################

flavours apply gruvbox-dark-hard

flavours build ./generated.yaml ./i3/default.mustache > ~/.config/i3/theme
flavours build ./gruvbox.yaml ./kitty/default-256.mustache > ~/.config/kitty/theme.conf
flavours build ./gruvbox.yaml ./polybar/default.mustache > ~/.config/polybar/theme

########################################
### Hooks                            ###
########################################

### KITTY ##############################
kitty @ set-colors --all ~/.config/kitty/theme.conf
kitty @ set-background-opacity 0.3
### VIM ################################
set +o errexit
vim --servername vim --remote-send '<Esc>:syntax sync fromstart<CR>'
nvr --nostart --remote-send '<Esc>:syntax sync fromstart<CR>'
set -o errexit
### i3 #################################
i3-msg reload
### POLYBAR ############################
polybar-msg cmd restart

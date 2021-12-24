#! /bin/bash

set -o errexit
set -o nounset

########################################
### Wallpaper                        ###
########################################

feh --bg-scale ./wallpaper/astronaut.jpg

########################################
### Colorscheme                      ###
########################################

flavours apply gruvbox-dark-hard

flavours build ./i3/scheme.yaml ./i3/default.mustache > ~/.config/i3/theme
flavours build ./kitty/scheme.yaml ./kitty/default-256.mustache > ~/.config/kitty/theme.conf
flavours build ./polybar/scheme.yaml ./polybar/default.mustache > ~/.config/polybar/theme

########################################
### Hooks                            ###
########################################

### KITTY ##############################
kitty @ set-colors --all ~/.config/kitty/theme.conf
### VIM ################################
vim --servername vim --remote-send '<Esc>:syntax sync fromstart<CR>'
nvr --nostart --remote-send '<Esc>:syntax sync fromstart<CR>'
### i3 #################################
i3-msg reload
### POLYBAR ############################
polybar-msg cmd restart

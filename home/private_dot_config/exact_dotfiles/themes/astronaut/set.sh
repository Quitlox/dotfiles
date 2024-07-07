#! /bin/bash

set -o errexit
set -o nounset

# Change Working Directory
cd "$(dirname "$0")"

########################################
### Wallpaper                        ###
########################################

feh --bg-scale ./wallpaper

########################################
### Colorscheme                      ###
########################################

# Custom
# ! TODO: ./i3/default.mustache is identical to default
flavours build ./generated.yaml ./i3/default.mustache > ~/.config/i3/theme
flavours build ./gruvbox.yaml ./kitty/default-256.mustache > ~/.config/kitty/theme.conf
flavours build ./gruvbox.yaml ./polybar/default.mustache > ~/.config/polybar/theme
flavours build ./generated.yaml ./rofi/colors.mustache > ~/.config/rofi/colors.rasi
# Default
flavours build ./generated.yaml ~/.local/share/flavours/base16/templates/zathura/templates/recolor.mustache > ~/.config/zathura/theme

########################################
### Hooks                            ###
########################################

### KITTY ##############################
kitty @ set-colors --all ~/.config/kitty/theme.conf
kitty @ set-background-opacity 0.3
### VIM ################################
set +o errexit
# Colorscheme
vim --servername vim --remote-send '<Esc>:colorscheme codedark | AirlineTheme codedark<CR>'
nvr -s --nostart --remote-send '<Esc>:colorscheme codedark | AirlineTheme codedark<CR>'
# Syntax highlighting
vim --servername vim --remote-send '<Esc>:syntax sync fromstart<CR>'
nvr -s --nostart --remote-send '<Esc>:syntax sync fromstart<CR>'
set -o errexit
### i3 #################################
i3-msg reload
### POLYBAR ############################
polybar-msg cmd restart

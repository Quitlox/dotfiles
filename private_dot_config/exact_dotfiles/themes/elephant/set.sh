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

flavours apply material


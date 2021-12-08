#!/bin/bash

source {{ joinPath .chezmoi.sourceDir .includeDir "/dep_all.sh" | quote }}

binformation "Running script: \"adjust_touch_screen.sh\""

# Automatically remap touch area of the screen to the touch screen
# More information: https://wiki.archlinux.org/index.php/touchscreen
# Related autorandr issue: https://github.com/phillipberndt/autorandr/issues/245
touchscreen="Raydium Corporation Raydium Touch System"
touchscreen_test=$(xinput --list | grep -e "${touchscreen}" | wc -l)
if [[ $touchscreen_test -eq 1 ]]; then
	information "Found touchscreen, remapping..."
	xinput --map-to-output "${touchscreen}" eDP
fi

#!/bin/bash

source "$_CHEZMOI_INCLUDE"

if ! command -v "xsetwacom" &> /dev/null
then
	berror "Missing dependency: 'xsetwacom'"
fi
if ! command -v "awk" &> /dev/null
then
	berror "Missing dependency: 'awk'"
fi

# Find the id of the pad
pad=$(xsetwacom --list devices \
	| awk --field-separator '\t' '/pad/ {split($2, ID, ": "); print ID[2];}')
stylus=$(xsetwacom --list devices \
	| awk --field-separator '\t' '/stylus/ {split($2, ID, ": "); print ID[2];}')

# Exit if tablet not connected
if [[ -z $pad ]]; then
	bwarning "Wacom Tablet not connected!"
	exit
fi

xsetwacom set $stylus MapToOutput 1920x1080+0+0

# Setup Tablet
xsetwacom set $pad Button 2 "key +ctrl z -ctrl"
xsetwacom set $pad Button 3 "key esc"
xsetwacom set $pad Button 8 "key +ctrl button 4 key -ctrl"
xsetwacom set $pad Button 9 "key +ctrl button 5 key -ctrl"
xsetwacom set $pad Button 10 "key +space"

success "Succesfully remapped Pad for use with Obsidian!"

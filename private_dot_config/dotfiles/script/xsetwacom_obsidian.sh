#!/bin/bash

if ! command -v "xsetwacom" &> /dev/null
then
	echo "Missing dependency: 'xsetwacom'"
fi
if ! command -v "awk" &> /dev/null
then
	echo "Missing dependency: 'awk'"
fi

# Find the id of the pad
id=$(xsetwacom --list devices \
	| awk --field-separator '\t' '/pad/ {split($2, ID, ": "); print ID[2];}')

# Exit if tablet not connected
if [[ -z $id ]]; then
	echo "Wacom Tablet not connected!"
	exit
fi

# Setup Tablet
xsetwacom set $id Button 2 "key +ctrl z -ctrl"
xsetwacom set $id Button 3 "key esc"
xsetwacom set $id Button 8 "key +ctrl button 4 key -ctrl"
xsetwacom set $id Button 9 "key +ctrl button 5 key -ctrl"
xsetwacom set $id Button 10 "key +space"

echo "Succesfully remapped Pad for use with Obsidian!"

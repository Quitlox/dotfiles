#!/bin/sh
# One-shot script to reopen eww bars on all monitors

# Close all open bars
eww close-all

i=0
# Loop over each monitor and open eww bar
monitors="$(hyprctl monitors | awk '/Monitor / {print $2}')"
echo "$monitors" | while IFS= read -r monitor; do
	eww open --screen $i --id "screen-$i" bar

    # Increment the index counter
    i=$((i + 1))
done

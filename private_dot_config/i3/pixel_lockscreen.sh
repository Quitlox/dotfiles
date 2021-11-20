#!/bin/bash

img=/tmp/i3lock.png

maim -o $img
convert $img -scale 10% -scale 1000% $img

i3lock -i $img

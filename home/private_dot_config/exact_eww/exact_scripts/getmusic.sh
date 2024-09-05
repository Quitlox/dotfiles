#!/bin/bash
title=$(playerctl metadata --format '{{ title }}')
count=$(echo -n "$title" | wc -c)
if [ -z "$title" ]; then
    echo "Nothing Playing..."
else
    echo $title
fi

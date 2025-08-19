#!/usr/bin/env bash

# Take a screenshot using grim
SCREENSHOT_PATH="/tmp/eww-screenshot-$(date +%s).png"
grim "$SCREENSHOT_PATH"
echo "$SCREENSHOT_PATH"
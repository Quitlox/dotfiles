#!/bin/bash

# Define the path to search for the profile
FIREFOX_PROFILE_PREFIX="$HOME/.mozilla/firefox"
USER_JS_SOURCE="./chezmoi_user.js"

# Find the directory matching '*.default-release'
shopt -s nullglob
profiles=($FIREFOX_PROFILE_PREFIX/*.default-release)
shopt -u nullglob

# Ensure that exactly one `.default.release` directory was found
if [ ${#profiles[@]} -ne 1 ]; then
    echo "Warning: Found ${#profiles[@]} directories ending with '.default-release'. There should be exactly one. Skiping user.js configuration."
    exit 0
fi

# Check if user.js exists at the source location
if [ ! -f "$USER_JS_SOURCE" ]; then
    echo "Error: $USER_JS_SOURCE does not exist."
    exit 1
fi

# Copy user.js to the target directory
target_dir="${profiles[0]}"
cp "$USER_JS_SOURCE" "$target_dir/"

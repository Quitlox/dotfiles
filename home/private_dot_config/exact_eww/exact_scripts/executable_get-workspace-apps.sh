#!/usr/bin/env bash

# Get workspace ID from argument
WORKSPACE_ID=$1

if [ -z "$WORKSPACE_ID" ]; then
    echo "[]"
    exit 0
fi

# Get all clients for the specified workspace
CLIENTS=$(hyprctl clients -j | jq -r --arg ws "$WORKSPACE_ID" '
    map(select(.workspace.id == ($ws | tonumber))) |
    group_by(.class) |
    map(.[0]) |
    .[0:3] |
    map({
        class: .class,
        title: .title,
        icon: .class
    })
')

# Function to find icon path for an application
find_icon() {
    local app_class="$1"
    local app_class_lower=$(echo "$app_class" | tr '[:upper:]' '[:lower:]')
    
    # Check common icon paths
    local icon_paths=(
        "/usr/share/icons/hicolor/48x48/apps/${app_class_lower}.png"
        "/usr/share/icons/hicolor/64x64/apps/${app_class_lower}.png"
        "/usr/share/icons/hicolor/128x128/apps/${app_class_lower}.png"
        "/usr/share/icons/hicolor/scalable/apps/${app_class_lower}.svg"
        "/usr/share/pixmaps/${app_class_lower}.png"
        "/usr/share/pixmaps/${app_class_lower}.svg"
    )
    
    # Check if desktop file exists and extract icon
    local desktop_file="/usr/share/applications/${app_class_lower}.desktop"
    if [ -f "$desktop_file" ]; then
        local icon_name=$(grep "^Icon=" "$desktop_file" | cut -d= -f2 | head -1)
        if [ -n "$icon_name" ]; then
            # If icon name is a full path
            if [ -f "$icon_name" ]; then
                echo "$icon_name"
                return
            fi
            
            # Otherwise search in standard locations
            for dir in /usr/share/icons/hicolor/*/apps /usr/share/pixmaps; do
                for ext in png svg; do
                    if [ -f "$dir/${icon_name}.${ext}" ]; then
                        echo "$dir/${icon_name}.${ext}"
                        return
                    fi
                done
            done
        fi
    fi
    
    # Try direct paths
    for path in "${icon_paths[@]}"; do
        if [ -f "$path" ]; then
            echo "$path"
            return
        fi
    done
    
    # Fallback to generic icon
    echo "/usr/share/icons/hicolor/48x48/apps/application-x-executable.png"
}

# Process each client and find its icon
echo "$CLIENTS" | jq -c '.[]' | while read -r client; do
    class=$(echo "$client" | jq -r '.class')
    title=$(echo "$client" | jq -r '.title')
    icon_path=$(find_icon "$class")
    
    echo "$client" | jq --arg icon "$icon_path" '. + {icon_path: $icon}'
done | jq -s '.'
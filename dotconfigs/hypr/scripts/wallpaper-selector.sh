#!/bin/bash

# Directory containing wallpapers
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
HYPRPAPER_CONFIG="$HOME/.config/hypr/hyprpaper.conf"

# Function to generate Wofi input with full path
generate_wallpaper_list() {
    find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) -print0 | while IFS= read -r -d '' wallpaper; do
        echo "img:$wallpaper"
    done
}

# Select wallpaper using Wofi with improved image preview
selected_wallpaper=$(generate_wallpaper_list | wofi --show dmenu --allow-images --width=70% --height=60% --columns=4 --image-size=300)

if [ -n "$selected_wallpaper" ]; then
    # Remove the img: prefix
    actual_wallpaper="${selected_wallpaper#img:}"
    
    # Update hyprpaper config
    # First, remove existing preload and wallpaper lines for this monitor
    sed -i '/^preload/d' "$HYPRPAPER_CONFIG"
    sed -i '/^wallpaper/d' "$HYPRPAPER_CONFIG"
    
    # Add new preload and wallpaper lines
    echo "preload = $actual_wallpaper" >> "$HYPRPAPER_CONFIG"
    echo "wallpaper = ,$actual_wallpaper" >> "$HYPRPAPER_CONFIG"
    
    # Restart hyprpaper to apply changes
    pkill hyprpaper
    hyprpaper &
    
    # Optional: notify user
    notify-send "Wallpaper Changed" "New wallpaper set" -i "$actual_wallpaper"
fi

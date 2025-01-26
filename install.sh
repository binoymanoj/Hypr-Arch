#!/bin/bash

# Update system
echo "Updating system..."
sudo pacman -Syu --noconfirm

# Install required packages
echo "Installing required packages..."
sudo pacman -S --noconfirm hyprland ghostty waybar wofi dunst swaylock hyprpaper hypridle neovim nautilus nautilus-file-roller nautilus-evince python3-nautilus NetworkManager-applet pavucontrol playerctl libnotify-tools grim wlsunset ImageMagick ttf-jetbrains-mono-nerd hyprland-qtutils
 
# Create configuration directories if not already present
echo "Creating configuration directories..."
mkdir -p ~/.config/{hypr,waybar,wofi,dunst,ghostty,swaylock,nvim}

# Copy configuration files
echo "Copying configuration files..."
cp -r dotconfigs/hypr/* ~/.config/hypr/
cp -r dotconfigs/waybar/* ~/.config/waybar/
cp -r dotconfigs/wofi/* ~/.config/wofi/
cp -r dotconfigs/dunst/* ~/.config/dunst/
cp -r dotconfigs/swaylock/* ~/.config/swaylock/
cp -r dotconfigs/ghostty/* ~/.config/ghostty/

# copy wallpaper to pictures folder
mkdir -p ~/Pictures/Wallpapers/
cp images/boy-coding-wallpaper.jpg ~/Pictures/Wallpapers/

# Set up wallpaper manager
echo "Setting up Hyprpaper..."
pkill hyprpaper || true
hyprpaper &

# Reload Waybar and other services
echo "Restarting Waybar..."
pkill waybar || true
waybar &

# Final message
echo "Installation complete! Log out and log back in for the changes to take effect."


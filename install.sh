#!/bin/bash

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
    echo "Please do not run as root/sudo. Script will ask for elevation when needed."
    exit 1
fi

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Spinner function for loading animation
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Function to print status messages
print_status() {
    echo -e "\n${BLUE}[*]${NC} $1"
}

# Function to print success messages
print_success() {
    echo -e "${GREEN}[+]${NC} $1"
}

# Function to print error messages
print_error() {
    echo -e "${RED}[-]${NC} $1"
}

# Function to show progress
show_progress() {
    echo -ne "${YELLOW}Progress: [$1] ${2}%${NC}\r"
}

# Function to notify
notify() {
    if command -v notify-send &> /dev/null; then
        notify-send "$1" "$2" -u normal
    fi
}

# Welcome message
clear
echo -e "${GREEN}=================================${NC}"
echo -e "${GREEN}  Hyprland Installation Script   ${NC}"
echo -e "${GREEN}=================================${NC}\n"

# Update system
print_status "Updating system..."
sudo pacman -Syu --noconfirm &
spinner $!
print_success "System updated"

# Installing git
print_status "Installing git and base-devel..."
sudo pacman -S --needed base-devel git --noconfirm &
spinner $!

# Installing yay
print_status "Installing yay AUR helper..."
mkdir -p ~/Applications
cd ~/Applications || exit
if [ ! -d "yay" ]; then
    git clone https://aur.archlinux.org/yay.git
    cd yay || exit
    makepkg -si --noconfirm &
    spinner $!
fi

# Install required packages
print_status "Installing required packages..."
sudo pacman -S --noconfirm hyprland fastfetch ttf-jetbrains-mono-nerd noto-fonts-emoji  \
    nautilus hyprctl ghostty waybar wofi rofi dunst swaylock-effects \
    hyprpaper hypridle neovim blueman bluez bluez-utils network-manager-applet pavucontrol \
    playerctl libnotify-tools grim slurp wlsunset ImageMagick zoxide \
    brightnessctl cliphist wl-clipboard zsh polkit-gnome ufw plocate &
spinner $!

# Installing AUR packages
print_status "Installing AUR packages..."
yay -S --noconfirm brave bibata-cursor-theme zsh-completions nvm &
spinner $!

# Setting up zsh shell
print_status "Setting up zsh shell..."
chsh -s "$(which zsh)"

# Configure bluetooth
print_status "Configuring bluetooth..."
sudo systemctl enable bluetooth 
sudo systemctl start bluetooth

# Create configuration directories
print_status "Creating configuration directories..."
mkdir -p ~/.config/{hypr,waybar,wofi,rofi,dunst,ghostty,swaylock,nvim}

# Copy configuration files
print_status "Copying configuration files..."
for dir in hypr waybar wofi rofi dunst swaylock ghostty; do
    cp -r "dotconfigs/$dir/"* ~/.config/"$dir"/ 2>/dev/null || true
    show_progress "##########" $((($dir * 100) / 7))
done

# Copy other config files
cp -r dotconfigs/.bashrc ~/.bashrc
cp -r dotconfigs/.zshrc ~/.zshrc

# Configure cursor theme
print_status "Configuring cursor theme..."
sudo mkdir -p /usr/share/icons/default/
cat << EOF | sudo tee /usr/share/icons/default/index.theme > /dev/null
[Icon Theme]
Inherits=Bibata-Modern-Classic
EOF

# Configure GTK-3.0 settings
mkdir -p ~/.config/gtk-3.0/
cat << EOF > ~/.config/gtk-3.0/settings.ini
[Settings]
gtk-cursor-theme-name=Bibata-Modern-Classic
EOF

# Configure Hyprland cursor
HYPR_CONF="$HOME/.config/hypr/hyprland.conf"
if [ ! -f "$HYPR_CONF" ]; then
    mkdir -p "$(dirname "$HYPR_CONF")"
    touch "$HYPR_CONF"
fi

if ! grep -q "XCURSOR_THEME" "$HYPR_CONF"; then
    echo -e "\n# Cursor configuration" >> "$HYPR_CONF"
    echo "env = XCURSOR_THEME,Bibata-Modern-Classic" >> "$HYPR_CONF"
    echo "env = XCURSOR_SIZE,20" >> "$HYPR_CONF"
fi

# Setting up ufw (firewall)
sudo ufw enable
   
# Setup wallpaper
print_status "Setting up wallpaper..."
mkdir -p ~/Pictures/Wallpapers/
cp images/boy-coding-wallpaper.jpg ~/Pictures/Wallpapers/

# Restart services
print_status "Restarting services..."
pkill hyprpaper waybar || true
hyprpaper &
waybar &

# Final notification
notify "Installation Complete" "Please restart Hyprland for all changes to take effect"

# Final message
echo -e "\n${GREEN}=================================${NC}"
echo -e "${GREEN}    Installation Complete!         ${NC}"
echo -e "${GREEN}=================================${NC}"
echo -e "\nPlease ${YELLOW}restart Hyprland${NC} for all changes to take effect.\n"

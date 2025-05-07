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

# Function to run command with sudo and spinner
# This ensures the sudo password prompt doesn't interfere with spinner
run_sudo_command() {
    local command_description=$1
    shift
    
    print_status "$command_description"
    
    # First authenticate with sudo to cache credentials
    sudo -v
    
    # Then run the actual command with spinner
    sudo "$@" &
    spinner $!
    
    print_success "$command_description completed"
}

# Function to run regular command with spinner
run_command() {
    local command_description=$1
    shift
    
    print_status "$command_description"
    "$@" &
    spinner $!
    print_success "$command_description completed"
}

# Welcome message
clear
echo -e "${GREEN}=================================${NC}"
echo -e "${GREEN}  Hyprland Installation Script   ${NC}"
echo -e "${GREEN}=================================${NC}\n"

# Pre-authenticate sudo to avoid password prompts during operations
print_status "Please enter your password to proceed with installation"
sudo -v

# Keep sudo credentials fresh for the duration of the script
(while true; do sudo -v; sleep 60; done) &
SUDO_KEEP_ALIVE_PID=$!

# Update system
run_sudo_command "Updating system" pacman -Syu --noconfirm

# Installing git
run_sudo_command "Installing git and base-devel" pacman -S --needed base-devel git --noconfirm

# Installing yay
print_status "Installing yay AUR helper..."
mkdir -p ~/Applications
cd ~/Applications || exit
if [ ! -d "yay" ]; then
    git clone https://aur.archlinux.org/yay.git
    cd yay || exit
    run_command "Building yay" makepkg -si --noconfirm
fi

# Install required packages
run_sudo_command "Installing required packages" pacman -S --noconfirm hyprland fastfetch ttf-jetbrains-mono-nerd noto-fonts-emoji \
    nautilus hyprctl ghostty waybar rofi-wayland rofi-emoji dunst \
    hyprpaper hypridle neovim blueman bluez bluez-utils network-manager-applet pavucontrol \
    playerctl libnotify-tools grim slurp wlsunset imagemagick pipewire pipewire-pulse zoxide \
    brightnessctl cliphist wl-clipboard zsh polkit-gnome ufw plocate fzf yazi gnome-system-monitor fwupd exfat-utils ntfs-3g

# Installing AUR packages
run_command "Installing AUR packages" yay -S --noconfirm brave-bin bibata-cursor-theme swaylock-effects zsh-completions nvm eog wofi-emoji

# Setting up zsh shell
print_status "Setting up zsh shell..."
chsh -s "$(which zsh)"

# Configure bluetooth
print_status "Configuring bluetooth..."
run_sudo_command "Enabling bluetooth service" systemctl enable bluetooth 
run_sudo_command "Starting bluetooth service" systemctl start bluetooth

# Create configuration directories
print_status "Creating configuration directories..."
mkdir -p ~/.config/{hypr,waybar,wofi,rofi,dunst,fastfetch,nvim,ghostty,swaylock,tmux,yazi,nvim}

# Copy configuration files
print_status "Copying configuration files..."
for dir in hypr waybar wofi rofi dunst swaylock ghostty; do
    cp -r "dotconfigs/$dir/"* ~/.config/"$dir"/ 2>/dev/null || true
    show_progress "##########" $((($dir * 100) / 7))
done

# Copy other config files
cp -r dotconfigs/.bashrc ~/.bashrc
cp -r dotconfigs/.zshrc ~/.zshrc

# Symlink .zshrc from .config to home folder ~ 
ln -s ~/.config/.zshrc ~/.zshrc

# Configure cursor theme
run_sudo_command "Configuring cursor theme" mkdir -p /usr/share/icons/default/
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
run_sudo_command "Enabling firewall" ufw enable

# Setting up TLP for (Power saving)
run_sudo_command "Installing TLP" pacman -S tlp tlp-rdw --noconfirm
run_sudo_command "Enabling TLP service" systemctl enable tlp
run_sudo_command "Starting TLP service" systemctl start tlp
   
# Setup wallpaper
print_status "Setting up wallpaper..."
mkdir -p ~/Pictures/Wallpapers/
cp images/boy-coding-wallpaper.jpg ~/Pictures/Wallpapers/

# Restart services
print_status "Restarting services..."
pkill hyprpaper waybar || true
hyprpaper &
waybar &

# Kill the sudo credential keeper
kill $SUDO_KEEP_ALIVE_PID 2>/dev/null || true

# Final notification
notify "Installation Complete" "Please restart Hyprland for all changes to take effect"

# Final message
echo -e "\n${GREEN}=================================${NC}"
echo -e "${GREEN}    Installation Complete!         ${NC}"
echo -e "${GREEN}=================================${NC}"
echo -e "\nPlease ${YELLOW}restart Hyprland${NC} for all changes to take effect.\n"

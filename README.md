# Arch Linux with Hyprland Configuration

Welcome to my Arch Linux Hyprland setup! This repository contains my personal configuration files and an installation script (`install.sh`) to set up a beautiful, minimal, and functional desktop environment. 

---

## Features

- **Window Manager**: [Hyprland](https://github.com/hyprwm/Hyprland) for a dynamic and modern Wayland compositor.
- **Terminal**: [Ghostty](https://github.com/ghostty/ghostty) for a sleek and minimal terminal experience.
- **Panel**: [Waybar](https://github.com/Alexays/Waybar) for a customizable and beautiful status bar.
- **Application Launcher**: [Wofi](https://hg.sr.ht/~scoopta/wofi) for a lightweight and stylish application launcher.
- **Notifications**: [Dunst](https://github.com/dunst-project/dunst) for minimal notification handling.
- **Screen Lock**: [Swaylock](https://github.com/swaywm/swaylock) for a secure and customizable lock screen.
- **Wallpaper Manager**: [Hyprpaper](https://github.com/hyprwm/Hyprland/wiki/Hyprpaper) to manage dynamic wallpapers.
- **Idle Manager**: [Hypridle](https://github.com/hyprwm/Hyprland/wiki/Hypridle) for power management and idle actions.

---

## Preview

### Full Desktop View
![Full Desktop Screenshot](./images/full-desktop.png)

### Individual Components

- **Terminal (Ghostty)**:
  ![Ghostty Screenshot](./images/ghostty.png)

- **Waybar**:
  ![Waybar Screenshot](./images/waybar.png)

- **Wofi**:
  ![Wofi Screenshot](./images/wofi.png)

- **Notifications (Dunst)**:
  ![Dunst Screenshot](./images/dunst.png)

- **Screen Lock (Swaylock)**:
  ![Swaylock Screenshot](./images/swaylock.jpg)

---

## Installation

To replicate this setup, follow these steps:

### Prerequisites
- Arch Linux installed and updated.
- Git installed.

### Steps

1. Clone this repository:
   ```bash
   git clone https://github.com/binoymanoj/Hypr-Arch.git
   cd Hypr-Arch/
   ```

2. Make the installation script executable:
   ```bash
   chmod +x install.sh
   ```

3. Run the installation script:
   ```bash
   ./install.sh
   ```

This script will:
- Install required packages.
- Configure Hyprland and its dependencies.
- Set up configuration files in the appropriate directories.

---

## Configuration

### Hyprland
Configuration files are located in `~/.config/hypr`. Custom keybindings, workspace settings, and layouts are defined here.

### Waybar
The Waybar configuration is located in `~/.config/waybar/config`. Styles are defined in `~/.config/waybar/style.css`.

---

## Screenshots

Screenshots are included in the `./images` directory for reference.

---

## Contributions

Feel free to open issues or submit pull requests to improve this setup.

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## Acknowledgments

- [Arch Wiki](https://wiki.archlinux.org/) for its extensive documentation.
- [Hyprland GitHub](https://github.com/hyprwm/Hyprland) for the incredible window manager.

---


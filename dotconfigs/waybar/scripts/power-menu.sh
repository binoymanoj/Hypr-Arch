#!/bin/bash

# Options with icons (requires Font Awesome)
shutdown="⏻  Shutdown"
reboot=" 🗘 Reboot"
logout="↩ Logout"
suspend="󰒲 Suspend"
lock="🔒 Lock"

# Get answer from rofi
selected_option=$(echo -e "$shutdown\n$reboot\n$logout\n$suspend\n$lock" | rofi -dmenu -i -p "Power Menu" -theme ~/.config/rofi/power.rasi)

# Do something based on selected option
case $selected_option in
    "$shutdown")
        systemctl poweroff
        ;;
    "$reboot")
        systemctl reboot
        ;;
    "$logout")
        hyprctl dispatch exit
        ;;
    "$suspend")
        systemctl suspend
        ;;
    "$lock")
        swaylock
        ;;
esac
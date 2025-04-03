#!/bin/bash

# Wait for Hyprland to fully start
sleep 2

# Move to workspace 10
hyprctl dispatch workspace 10

# Launch your application
ticktick &

# Moveback to workspace 1
# hyprctl dispatch workspace 1

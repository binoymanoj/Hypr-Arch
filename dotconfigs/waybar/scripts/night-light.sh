#!/bin/bash

CONFIG_FILE="$HOME/.config/wlsunset/config"
PID_FILE="/tmp/wlsunset.pid"

# Ensure required directories exist
mkdir -p "$(dirname "$CONFIG_FILE")"
touch "$CONFIG_FILE"

# Read current temperature or set default with proper validation
read_temp() {
    local saved_temp
    if [ -f "$CONFIG_FILE" ]; then
        saved_temp=$(cat "$CONFIG_FILE")
        if [[ "$saved_temp" =~ ^[0-9]+$ ]]; then
            echo "$saved_temp"
        else
            echo "4500"  # Default if not a valid number
        fi
    else
        echo "4500"  # Default if file doesn't exist
    fi
}

temp=$(read_temp)

# Function to check if wlsunset is running
is_running() {
    if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
        return 0
    else
        [ -f "$PID_FILE" ] && rm "$PID_FILE"
        return 1
    fi
}

# Function to start wlsunset
start_wlsunset() {
    pkill wlsunset 2>/dev/null
    
    # Ensure temperature is within valid range
    if [ "$temp" -lt 2500 ]; then
        temp=2500
    elif [ "$temp" -gt 6500 ]; then
        temp=6500
    fi
    
    # Use wlsunset's built-in time functionality
    # Start at 21:00 (9 PM) and end at 06:00 (7 AM)
    wlsunset -T 6500 -t "$temp" -s 21:00 -S 07:00 &
    
    echo $! > "$PID_FILE"
}

# Function to stop wlsunset
stop_wlsunset() {
    if [ -f "$PID_FILE" ]; then
        kill "$(cat "$PID_FILE")" 2>/dev/null
        rm "$PID_FILE"
    else
        pkill wlsunset 2>/dev/null
    fi
}

case "$1" in
    "toggle")
        if is_running; then
            stop_wlsunset
        else
            start_wlsunset
        fi
        ;;
    "increase")
        if [[ "$temp" =~ ^[0-9]+$ ]] && [ "$temp" -lt 6500 ]; then
            temp=$((temp + 500))
            echo "$temp" > "$CONFIG_FILE"
            if is_running; then
                stop_wlsunset
                start_wlsunset
            fi
        fi
        ;;
    "decrease")
        if [[ "$temp" =~ ^[0-9]+$ ]] && [ "$temp" -gt 2500 ]; then
            temp=$((temp - 500))
            echo "$temp" > "$CONFIG_FILE"
            if is_running; then
                stop_wlsunset
                start_wlsunset
            fi
        fi
        ;;
    "status")
        if is_running; then
            echo "{\"text\": \"󰖔\", \"class\": \"on\", \"tooltip\": \"Night Light: ON ($temp K)\"}"
        else
            echo "{\"text\": \"󰖨\", \"class\": \"off\", \"tooltip\": \"Night Light: OFF ($temp K)\"}"
        fi
        ;;
esac

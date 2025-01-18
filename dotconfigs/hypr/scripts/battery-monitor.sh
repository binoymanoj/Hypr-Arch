#!/bin/bash

# Set battery path - you may need to adjust this path
BATTERY_PATH="/sys/class/power_supply/BAT1"

SOUND="/usr/share/sounds/freedesktop/stereo/message.oga"

LAST_NOTIFY_LEVEL=100

# Function to play sound and show notification
notify_with_sound() {
    local urgency=$1
    local title=$2
    local message=$3
    local icon=$4
    local sound_file=$5

    # Show notification
    notify-send -u "$urgency" "$title" "$message" -i "$icon"
    
    # Play sound if file exists
    if [ -f "$sound_file" ]; then
        paplay "$sound_file"
    fi
}

while true; do
    # Check if battery exists
    if [ ! -d "$BATTERY_PATH" ]; then
        echo "Battery not found at $BATTERY_PATH"
        exit 1
    fi

    # Get battery level and charging status
    BATTERY_LEVEL=$(cat "$BATTERY_PATH/capacity")
    CHARGING_STATUS=$(cat "$BATTERY_PATH/status")

    # Only send notifications if battery is discharging
    if [ "$CHARGING_STATUS" != "Charging" ] && [ "$CHARGING_STATUS" != "Full" ]; then
        # Check different battery levels and notify accordingly
        if [ "$BATTERY_LEVEL" -le 5 ] && [ "$LAST_NOTIFY_LEVEL" -gt 5 ]; then
            notify_with_sound "critical" "Battery Critical!" "Battery level is ${BATTERY_LEVEL}% - Connect charger immediately" "battery-empty" "$SOUND"
            LAST_NOTIFY_LEVEL=5
        elif [ "$BATTERY_LEVEL" -le 10 ] && [ "$LAST_NOTIFY_LEVEL" -gt 10 ]; then
            notify_with_sound "critical" "Battery Very Low!" "Battery level is ${BATTERY_LEVEL}% - Connect charger now" "battery-low" "$SOUND"
            LAST_NOTIFY_LEVEL=10
        elif [ "$BATTERY_LEVEL" -le 20 ] && [ "$LAST_NOTIFY_LEVEL" -gt 20 ]; then
            notify_with_sound "normal" "Battery Low" "Battery level is ${BATTERY_LEVEL}%" "battery-low" "$SOUND"
            LAST_NOTIFY_LEVEL=20
        fi
    else
        # Reset notification level when charging
        LAST_NOTIFY_LEVEL=100
    fi

    # Sleep for 60 seconds before checking again
    sleep 60
done

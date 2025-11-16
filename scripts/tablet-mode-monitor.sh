#!/bin/bash
# Tablet mode monitor for Lenovo X1 Yoga
# Automatically starts/stops Onboard keyboard based on tablet mode

TABLET_MODE_FILE="/sys/devices/platform/thinkpad_acpi/hotkey_tablet_mode"
PREVIOUS_STATE=""

echo "Tablet mode monitor started"

# Function to ensure Onboard is docked at bottom (using 'top' due to orientation)
ensure_bottom_dock() {
    gsettings set org.onboard.window docking-edge 'top'
}

while true; do
    if [ -f "$TABLET_MODE_FILE" ]; then
        CURRENT_STATE=$(cat "$TABLET_MODE_FILE")

        if [ "$CURRENT_STATE" != "$PREVIOUS_STATE" ]; then
            if [ "$CURRENT_STATE" -eq 1 ]; then
                # Entering tablet mode
                echo "Tablet mode detected - starting Onboard"
                ensure_bottom_dock
                onboard &
            else
                # Exiting tablet mode
                echo "Laptop mode detected - stopping Onboard"
                pkill -f onboard
            fi
            PREVIOUS_STATE="$CURRENT_STATE"
        fi

        # If in tablet mode, continuously enforce bottom docking
        # This fixes the issue where rotation changes docking edge
        if [ "$CURRENT_STATE" -eq 1 ]; then
            ensure_bottom_dock
        fi
    else
        echo "Error: ThinkPad ACPI tablet mode file not found"
        sleep 5
    fi
    sleep 1
done

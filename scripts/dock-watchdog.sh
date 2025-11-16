#!/bin/bash
# Ubuntu Dock watchdog - keeps the dock active

echo "Dock watchdog started"

while true; do
    # Check if dock is inactive
    STATE=$(gnome-extensions info ubuntu-dock@ubuntu.com 2>/dev/null | grep "State:" | awk '{print $2}')

    if [ "$STATE" = "INACTIVE" ]; then
        echo "Dock is INACTIVE - reactivating..."
        gnome-extensions disable ubuntu-dock@ubuntu.com 2>/dev/null
        sleep 0.5
        gnome-extensions enable ubuntu-dock@ubuntu.com 2>/dev/null
        echo "Dock reactivated"
    fi

    sleep 5
done

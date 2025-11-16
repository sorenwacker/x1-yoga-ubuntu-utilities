#!/bin/bash
# Increase brightness and show notification
result=$(gdbus call --session \
    --dest org.gnome.SettingsDaemon.Power \
    --object-path /org/gnome/SettingsDaemon/Power \
    --method org.gnome.SettingsDaemon.Power.Screen.StepUp 2>&1)

# Extract brightness percentage
brightness=$(echo "$result" | grep -oP '\(\K\d+' | head -1)

# Show notification
if [ -n "$brightness" ]; then
    notify-send -t 1000 -h string:x-canonical-private-synchronous:brightness -h int:value:$brightness "Brightness: ${brightness}%" -i display-brightness-symbolic
fi

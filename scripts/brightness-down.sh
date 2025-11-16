#!/bin/bash
# Decrease brightness and show OSD
result=$(gdbus call --session \
    --dest org.gnome.SettingsDaemon.Power \
    --object-path /org/gnome/SettingsDaemon/Power \
    --method org.gnome.SettingsDaemon.Power.Screen.StepDown 2>&1)

# Extract brightness percentage
brightness=$(echo "$result" | grep -oP '\(\K\d+' | head -1)

# Show OSD slider (requires Custom OSD extension)
if [ -n "$brightness" ]; then
    level=$(echo "scale=2; $brightness / 100" | bc)
    GSETTINGS_SCHEMA_DIR=$HOME/.local/share/gnome-shell/extensions/custom-osd@neuromorph/schemas \
        gsettings set org.gnome.shell.extensions.custom-osd showosd "$RANDOM,display-brightness-symbolic,,${level}"
fi

#!/bin/bash
# Increase brightness and show OSD
result=$(gdbus call --session \
    --dest org.gnome.SettingsDaemon.Power \
    --object-path /org/gnome/SettingsDaemon/Power \
    --method org.gnome.SettingsDaemon.Power.Screen.StepUp 2>&1)

# Extract brightness percentage
brightness=$(echo "$result" | awk -F'[(),]' '{print $2}' | tr -d ' ')

# Show OSD slider (requires Custom OSD extension)
if [ -n "$brightness" ]; then
    level=$(LC_NUMERIC=C awk "BEGIN {printf \"%.2f\", $brightness / 100}")
    GSETTINGS_SCHEMA_DIR=$HOME/.local/share/gnome-shell/extensions/custom-osd@neuromorph/schemas \
        gsettings set org.gnome.shell.extensions.custom-osd showosd "$RANDOM,display-brightness-symbolic,,${level}"
fi

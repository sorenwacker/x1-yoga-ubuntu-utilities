#!/bin/bash
# Use GNOME's D-Bus interface to change brightness with OSD
gdbus call --session \
    --dest org.gnome.SettingsDaemon.Power \
    --object-path /org/gnome/SettingsDaemon/Power \
    --method org.gnome.SettingsDaemon.Power.Screen.StepUp > /dev/null 2>&1

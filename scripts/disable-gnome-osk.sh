#!/bin/bash
# Disable GNOME Shell built-in OSK permanently

sleep 5  # Wait for GNOME Shell to fully start

# Disable the built-in OSK
busctl --user call org.gnome.Shell /org/gnome/Shell org.gnome.Shell Eval s 'Main.keyboard.enabled = false;'

echo "GNOME Shell OSK disabled"

#!/bin/bash
# Uninstallation script for X1 Yoga Ubuntu Utilities

echo "======================================"
echo "X1 Yoga Ubuntu Utilities Uninstaller"
echo "======================================"
echo ""

# Stop and disable services
echo "Stopping services..."
systemctl --user stop tablet-mode-monitor.service 2>/dev/null || true
systemctl --user stop dock-watchdog.service 2>/dev/null || true
systemctl --user disable tablet-mode-monitor.service 2>/dev/null || true
systemctl --user disable dock-watchdog.service 2>/dev/null || true

# Remove user scripts
echo "Removing user scripts..."
rm -f ~/.local/bin/tablet-mode-monitor.sh
rm -f ~/.local/bin/dock-watchdog.sh
rm -f ~/.local/bin/disable-gnome-osk.sh

# Remove system-wide scripts (requires sudo)
echo "Removing system-wide brightness scripts..."
sudo rm -f /usr/local/bin/brightness-up.sh
sudo rm -f /usr/local/bin/brightness-down.sh

# Remove systemd services
echo "Removing systemd services..."
rm -f ~/.config/systemd/user/tablet-mode-monitor.service
rm -f ~/.config/systemd/user/dock-watchdog.service
systemctl --user daemon-reload

# Remove Nautilus script
echo "Removing Nautilus scripts..."
rm -f ~/.local/share/nautilus/scripts/Scan\ with\ ClamAV

# Remove autostart
echo "Removing autostart entries..."
rm -f ~/.config/autostart/disable-gnome-osk.desktop

# Remove Custom OSD extension
echo "Removing Custom OSD extension..."
gnome-extensions disable custom-osd@neuromorph 2>/dev/null || true
rm -rf ~/.local/share/gnome-shell/extensions/custom-osd@neuromorph

# Remove brightness keybindings
echo "Removing brightness keybindings..."
current_bindings=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)
# Find and remove brightness keybindings
for binding_path in $(echo "$current_bindings" | grep -oP "'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom[0-9]+/'" | tr -d "'"); do
    name=$(gsettings get org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"$binding_path" name 2>/dev/null | tr -d "'")
    if [ "$name" = "Brightness Up" ] || [ "$name" = "Brightness Down" ]; then
        # Remove this binding from the list
        current_bindings=$(echo "$current_bindings" | sed "s|, '$binding_path'||g" | sed "s|'$binding_path', ||g" | sed "s|'$binding_path'||g")
        # Reset the binding settings
        gsettings reset org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"$binding_path" name 2>/dev/null || true
        gsettings reset org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"$binding_path" command 2>/dev/null || true
        gsettings reset org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"$binding_path" binding 2>/dev/null || true
    fi
done
# Update the custom keybindings list
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$current_bindings"

echo ""
echo "======================================"
echo "Uninstallation Complete!"
echo "======================================"
echo ""
echo "All X1 Yoga utilities have been removed."
echo ""
echo "Note: Log out and log back in to fully remove Custom OSD extension"
echo ""

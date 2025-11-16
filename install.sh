#!/bin/bash
# Installation script for X1 Yoga Ubuntu Utilities

set -e

echo "======================================"
echo "X1 Yoga Ubuntu Utilities Installer"
echo "======================================"
echo ""

# Create directories
echo "Creating directories..."
mkdir -p ~/.local/bin
mkdir -p ~/.config/systemd/user
mkdir -p ~/.local/share/nautilus/scripts
mkdir -p ~/.config/autostart

# Install user-specific scripts
echo "Installing user-specific scripts..."
cp scripts/tablet-mode-monitor.sh ~/.local/bin/
cp scripts/dock-watchdog.sh ~/.local/bin/
cp scripts/disable-gnome-osk.sh ~/.local/bin/
chmod +x ~/.local/bin/tablet-mode-monitor.sh
chmod +x ~/.local/bin/dock-watchdog.sh
chmod +x ~/.local/bin/disable-gnome-osk.sh

# Install system-wide scripts (requires sudo)
echo "Installing system-wide brightness scripts..."
sudo cp scripts/brightness-up.sh /usr/local/bin/
sudo cp scripts/brightness-down.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/brightness-up.sh
sudo chmod +x /usr/local/bin/brightness-down.sh

# Install systemd services
echo "Installing systemd services..."
cp systemd/tablet-mode-monitor.service ~/.config/systemd/user/
cp systemd/dock-watchdog.service ~/.config/systemd/user/

# Install Nautilus script
echo "Installing Nautilus ClamAV script..."
cp nautilus-scripts/Scan\ with\ ClamAV ~/.local/share/nautilus/scripts/
chmod +x ~/.local/share/nautilus/scripts/Scan\ with\ ClamAV

# Install autostart entry
echo "Installing autostart entries..."
cat > ~/.config/autostart/disable-gnome-osk.desktop <<EOF
[Desktop Entry]
Type=Application
Name=Disable GNOME OSK
Exec=$HOME/.local/bin/disable-gnome-osk.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
EOF

# Install Custom OSD extension
echo "Installing Custom OSD extension..."
CUSTOM_OSD_DIR="$HOME/.local/share/gnome-shell/extensions/custom-osd@neuromorph"
if [ ! -d "$CUSTOM_OSD_DIR" ]; then
    git clone https://github.com/neuromorph/custom-osd.git "$CUSTOM_OSD_DIR"
    glib-compile-schemas "$CUSTOM_OSD_DIR/schemas/"
    echo "  ✅ Custom OSD extension installed"
else
    echo "  ℹ Custom OSD extension already installed"
fi

# Enable Custom OSD extension (will take effect after logout/login)
gnome-extensions enable custom-osd@neuromorph 2>/dev/null || echo "  ⚠ Extension will be enabled after logout/login"

# Apply dark red theme to Custom OSD
echo "Applying dark red theme to OSD..."
SCHEMA_DIR="$HOME/.local/share/gnome-shell/extensions/custom-osd@neuromorph/schemas"
gsettings --schemadir "$SCHEMA_DIR" set org.gnome.shell.extensions.custom-osd bgcolor "['0.0', '0.0', '0.0', '1.0']"     # Pure black background
gsettings --schemadir "$SCHEMA_DIR" set org.gnome.shell.extensions.custom-osd bcolor "['0.53', '0.0', '0.0', '1.0']"    # Dark red border
gsettings --schemadir "$SCHEMA_DIR" set org.gnome.shell.extensions.custom-osd levcolor "['1.0', '0.0', '0.0', '1.0']"   # Bright red level/slider
gsettings --schemadir "$SCHEMA_DIR" set org.gnome.shell.extensions.custom-osd color "['1.0', '1.0', '1.0', '1.0']"      # White text/icon
echo "  ✅ Dark red theme applied to OSD"

# Set up brightness keybindings
echo "Setting up brightness keybindings..."
# Get current custom keybindings
current_bindings=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)

# Find next available slot
slot=0
while echo "$current_bindings" | grep -q "custom$slot"; do
    slot=$((slot + 1))
done

# Add brightness-up keybinding
custom_path="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$slot/"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"$custom_path" name 'Brightness Up'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"$custom_path" command '/usr/local/bin/brightness-up.sh'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"$custom_path" binding 'XF86MonBrightnessUp'

# Add brightness-down keybinding
slot=$((slot + 1))
custom_path="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$slot/"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"$custom_path" name 'Brightness Down'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"$custom_path" command '/usr/local/bin/brightness-down.sh'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"$custom_path" binding 'XF86MonBrightnessDown'

# Update the list of custom keybindings
if [ "$current_bindings" = "@as []" ] || [ "$current_bindings" = "[]" ]; then
    # No existing bindings
    new_bindings="['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$((slot-1))/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$slot/']"
else
    # Add to existing bindings
    new_bindings=$(echo "$current_bindings" | sed "s/]$/, '\/org\/gnome\/settings-daemon\/plugins\/media-keys\/custom-keybindings\/custom$((slot-1))\/', '\/org\/gnome\/settings-daemon\/plugins\/media-keys\/custom-keybindings\/custom$slot\/']/" | sed "s/\[,/[/")
fi
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$new_bindings"

echo "  ✅ Brightness keybindings configured"

# Enable and start services
echo "Enabling systemd services..."
systemctl --user daemon-reload
systemctl --user enable tablet-mode-monitor.service
systemctl --user enable dock-watchdog.service
systemctl --user start tablet-mode-monitor.service
systemctl --user start dock-watchdog.service

echo ""
echo "======================================"
echo "Installation Complete!"
echo "======================================"
echo ""
echo "Installed components:"
echo "  ✅ Tablet mode monitor (running)"
echo "  ✅ Dock watchdog (running)"
echo "  ✅ GNOME OSK disabler (will run on next login)"
echo "  ✅ ClamAV Nautilus integration"
echo "  ✅ Brightness control scripts (/usr/local/bin/brightness-*.sh)"
echo "  ✅ Custom OSD extension with dark red theme (requires logout/login)"
echo "  ✅ Brightness keybindings (XF86MonBrightnessUp/Down)"
echo ""
echo "Services status:"
systemctl --user status tablet-mode-monitor.service --no-pager | grep "Active:"
systemctl --user status dock-watchdog.service --no-pager | grep "Active:"
echo ""
echo "Notes:"
echo "  - Flip to tablet mode to test Onboard keyboard"
echo "  - Right-click files in Nautilus → Scripts → 'Scan with ClamAV'"
echo "  - For ClamAV scanning, install: sudo apt install clamav"
echo "  - IMPORTANT: Log out and log back in to activate Custom OSD extension"
echo "  - After login, brightness keys will show OSD slider"
echo ""
echo "View logs:"
echo "  journalctl --user -u tablet-mode-monitor.service -f"
echo "  journalctl --user -u dock-watchdog.service -f"
echo ""

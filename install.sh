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

# Install scripts
echo "Installing scripts..."
cp scripts/tablet-mode-monitor.sh ~/.local/bin/
cp scripts/dock-watchdog.sh ~/.local/bin/
cp scripts/disable-gnome-osk.sh ~/.local/bin/
cp scripts/brightness-up.sh ~/.local/bin/
cp scripts/brightness-down.sh ~/.local/bin/
chmod +x ~/.local/bin/tablet-mode-monitor.sh
chmod +x ~/.local/bin/dock-watchdog.sh
chmod +x ~/.local/bin/disable-gnome-osk.sh
chmod +x ~/.local/bin/brightness-up.sh
chmod +x ~/.local/bin/brightness-down.sh

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
echo "  ✅ Brightness control scripts (brightness-up.sh, brightness-down.sh)"
echo ""
echo "Services status:"
systemctl --user status tablet-mode-monitor.service --no-pager | grep "Active:"
systemctl --user status dock-watchdog.service --no-pager | grep "Active:"
echo ""
echo "Notes:"
echo "  - Flip to tablet mode to test Onboard keyboard"
echo "  - Right-click files in Nautilus → Scripts → 'Scan with ClamAV'"
echo "  - For ClamAV scanning, install: sudo apt install clamav"
echo "  - Brightness scripts require Custom OSD extension for OSD display"
echo "  - Map brightness keys to ~/.local/bin/brightness-up.sh and brightness-down.sh"
echo ""
echo "View logs:"
echo "  journalctl --user -u tablet-mode-monitor.service -f"
echo "  journalctl --user -u dock-watchdog.service -f"
echo ""

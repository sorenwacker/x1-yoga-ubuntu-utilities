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

echo ""
echo "======================================"
echo "Uninstallation Complete!"
echo "======================================"
echo ""
echo "All X1 Yoga utilities have been removed."
echo ""

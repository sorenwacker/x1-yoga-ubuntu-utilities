# Lenovo X1 Yoga Ubuntu Utilities

Essential utilities and fixes for running Ubuntu on Lenovo X1 Yoga 2-in-1 laptops (2nd generation and similar models).

## Overview

This repository contains scripts and configurations to fix common issues and enhance the experience of running Ubuntu GNOME on convertible laptops like the Lenovo X1 Yoga.

## Features

### 🔄 Tablet Mode Support
- **Auto-launch onscreen keyboard** when switching to tablet mode
- **Automatic detection** using ThinkPad ACPI interface
- **Clean switching** between laptop and tablet modes

### 🖥️ Display & Dock Fixes
- **Dock watchdog** - Prevents Ubuntu Dock from disappearing
- **OSK disabler** - Disables conflicting GNOME onscreen keyboard
- Works with OLED displays and standard LCDs

### 🛡️ Security Integration
- **ClamAV Nautilus integration** - Right-click virus scanning in file manager
- Progress indicators and detailed scan results
- Automatic scan history logging

## Tested On

- **Hardware**: Lenovo X1 Yoga 2nd Generation
- **OS**: Ubuntu 24.04 (Noble Numbat) with GNOME 46
- **Display**: OLED 2560x1440

Should work on:
- Other X1 Yoga generations
- Similar ThinkPad convertibles with OLED displays
- Ubuntu 22.04+ with GNOME 40+

## Installation

### Quick Install

```bash
git clone https://github.com/sorenwacker/x1-yoga-ubuntu-utilities.git
cd x1-yoga-ubuntu-utilities
chmod +x install.sh
./install.sh
```

**Note:** The repository is just for distribution. The `install.sh` script copies all files to proper system directories (`~/.local/bin/`, `~/.config/systemd/user/`, etc.). After installation, you can delete the cloned repository directory if desired - everything runs from system locations.

### What Gets Installed

1. **Scripts** → `~/.local/bin/`
   - `tablet-mode-monitor.sh`
   - `dock-watchdog.sh`
   - `disable-gnome-osk.sh`

2. **Systemd Services** → `~/.config/systemd/user/`
   - `tablet-mode-monitor.service`
   - `dock-watchdog.service`

3. **Nautilus Scripts** → `~/.local/share/nautilus/scripts/`
   - `Scan with ClamAV`

4. **Autostart** → `~/.config/autostart/`
   - `disable-gnome-osk.desktop`

## Components

### Tablet Mode Monitor

Automatically detects tablet mode using the ThinkPad ACPI interface and launches/stops Onboard keyboard.

**Features:**
- Monitors `/sys/devices/platform/thinkpad_acpi/hotkey_tablet_mode`
- Launches Onboard when flipping to tablet mode
- Stops Onboard when returning to laptop mode
- Runs as systemd user service

**Onboard Configuration:**
- Full screen width docking
- Fixed aspect ratio
- Customizable position

### Dock Watchdog

Prevents Ubuntu Dock from becoming inactive and disappearing.

**Features:**
- Monitors dock state every 5 seconds
- Automatically restarts dock if it becomes inactive
- Runs as systemd user service
- No manual intervention needed

### GNOME OSK Disabler

Disables the built-in GNOME onscreen keyboard to prevent conflicts with Onboard.

**Features:**
- Runs on startup
- Prevents GNOME keyboard from auto-showing
- Allows Onboard to work without interference

### ClamAV Nautilus Integration

Adds virus scanning to the right-click context menu in Files (Nautilus).

**Features:**
- Right-click any file/folder → Scripts → "Scan with ClamAV"
- Progress indicator during scanning
- Detailed results with infected file information
- Scan history saved to `~/.clamav-scan-history.log`

**Requirements:**
- ClamAV installed (`sudo apt install clamav`)

## Manual Installation

If you prefer to install components individually:

### Tablet Mode Monitor

```bash
# Copy script
cp scripts/tablet-mode-monitor.sh ~/.local/bin/
chmod +x ~/.local/bin/tablet-mode-monitor.sh

# Install systemd service
cp systemd/tablet-mode-monitor.service ~/.config/systemd/user/
systemctl --user enable tablet-mode-monitor.service
systemctl --user start tablet-mode-monitor.service
```

### Dock Watchdog

```bash
# Copy script
cp scripts/dock-watchdog.sh ~/.local/bin/
chmod +x ~/.local/bin/dock-watchdog.sh

# Install systemd service
cp systemd/dock-watchdog.service ~/.config/systemd/user/
systemctl --user enable dock-watchdog.service
systemctl --user start dock-watchdog.service
```

### ClamAV Nautilus Script

```bash
# Install ClamAV if not already installed
sudo apt install clamav

# Copy script
mkdir -p ~/.local/share/nautilus/scripts
cp nautilus-scripts/Scan\ with\ ClamAV ~/.local/share/nautilus/scripts/
chmod +x ~/.local/share/nautilus/scripts/Scan\ with\ ClamAV

# Restart Nautilus
pkill nautilus
```

## Troubleshooting

### Tablet Mode Not Detected

Check if ThinkPad ACPI is available:
```bash
cat /sys/devices/platform/thinkpad_acpi/hotkey_tablet_mode
```
Should return `0` (laptop) or `1` (tablet).

### Dock Still Disappearing

Check watchdog status:
```bash
systemctl --user status dock-watchdog.service
```

View logs:
```bash
journalctl --user -u dock-watchdog.service -f
```

### Onboard Not Appearing

Check service status:
```bash
systemctl --user status tablet-mode-monitor.service
```

Test manually:
```bash
onboard
```

### ClamAV Scan Not Working

Ensure ClamAV is installed and running:
```bash
sudo systemctl status clamav-daemon
```

Update virus definitions:
```bash
sudo freshclam
```

## Uninstallation

```bash
cd x1-yoga-ubuntu-utilities
./uninstall.sh
```

Or manually:
```bash
# Stop and disable services
systemctl --user stop tablet-mode-monitor.service dock-watchdog.service
systemctl --user disable tablet-mode-monitor.service dock-watchdog.service

# Remove files
rm ~/.local/bin/{tablet-mode-monitor.sh,dock-watchdog.sh,disable-gnome-osk.sh}
rm ~/.config/systemd/user/{tablet-mode-monitor.service,dock-watchdog.service}
rm ~/.local/share/nautilus/scripts/Scan\ with\ ClamAV
rm ~/.config/autostart/disable-gnome-osk.desktop
```

## Configuration

### Tablet Mode Monitor

Edit `~/.local/bin/tablet-mode-monitor.sh` to customize:
- Onboard docking position
- Polling interval
- Tablet mode detection file path

### Dock Watchdog

Edit `~/.local/bin/dock-watchdog.sh` to customize:
- Check interval (default: 5 seconds)

## Related Projects

- [icc-brightness-safe](https://github.com/sorenwacker/icc-brightness-safe) - OLED brightness control with blackout prevention
- [gnome-dark-red-theme](https://github.com/sorenwacker/gnome-dark-red-theme) - Dark theme optimized for OLED displays

## Contributing

Issues and pull requests welcome! If you have a X1 Yoga or similar convertible and encounter problems or have improvements, please contribute.

## License

MIT License - See LICENSE file for details

## Acknowledgments

- ThinkPad ACPI kernel module for tablet mode detection
- Onboard project for the onscreen keyboard
- Ubuntu Dock/Dash to Dock developers
- ClamAV antivirus project

## Author

Soren Wacker
- GitHub: [@sorenwacker](https://github.com/sorenwacker)

# Hyprland Dotfiles

A modern, aesthetic Hyprland configuration with dynamic theming, smooth animations, and a complete desktop environment.

![Hyprland](https://img.shields.io/badge/Hyprland-Latest-blue)
![Wayland](https://img.shields.io/badge/Wayland-Compositor-green)
![License](https://img.shields.io/badge/License-MIT-yellow)

## ✨ Features

- **Dynamic Theming** - Colors extracted from wallpapers using `wallust`
- **Smooth Animations** - Custom bezier curves for buttery smooth transitions
- **Modular Config** - Organized into logical sections
- **Complete Environment** - Everything you need for a productive workflow
- **Battery Optimized** - TLP configuration for laptops
- **Eye Comfort** - Built-in blue light filter with hyprsunset
- **Enhanced Clipboard** - Persistent clipboard history with search (sqlite3)
- **Quick Menus** - Rofi menus for WiFi, Bluetooth, Power, and more
- **Theme Switcher** - Toggle between light and dark modes
- **Monitor Profiles** - Save and restore monitor layouts

## 📦 What's Included

| Component | Application |
|-----------|-------------|
| Window Manager | Hyprland |
| Status Bar | Waybar |
| Notifications | SwayNC |
| Launcher | Rofi |
| Terminal | Kitty |
| Shell | Fish + Oh-My-Posh |
| Wallpaper | swww |
| Colors | wallust |
| Lock Screen | Hyprlock |
| Idle Management | Hypridle |
| Logout Menu | wlogout |
| Emoji Picker | Rofimoji |
| Clipboard Manager | Enhanced with sqlite3 |
| Display Manager | SDDM (Sugar Candy theme) |
| Power Management | TLP |

## 🚀 Quick Start

### Prerequisites

- Arch Linux (or Arch-based distro)
- `git` installed
- AUR helper (yay or paru) recommended

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/dots.git ~/dots
   cd ~/dots
   ```

2. **Run the installer**
   ```bash
   ./install.sh
   # Or use make: make install
   ```

3. **Follow the prompts** to choose full setup, packages only, or configs only

4. **Set fish as default shell** (optional but recommended)
   ```bash
   chsh -s /usr/bin/fish
   ```

5. **Add wallpapers**
   ```bash
   ./scripts/download-wallpapers.sh
   # Or manually copy to ~/Pictures/Wallpapers5/
   ```

6. **Enable services**
   ```bash
   sudo systemctl enable --now sddm
   sudo systemctl enable --now tlp
   ```

7. **Reboot or log out and back in**

## 🎮 Keybindings

### Applications

| Keybinding | Action |
|------------|--------|
| `Super + Enter` | Open terminal (kitty) |
| `Super + T` | Toggle light/dark theme |
| `Super + Space` | Open launcher (rofi) |
| `Super + E` | Open file manager (nautilus) |
| `Super + b` | Open browser (zen) |
| `Super + I` | Open code editor |
| `Super + r` | Open ranger |

### Window Management

| Keybinding | Action |
|------------|--------|
| `Super + W` | Close window |
| `Super + V` | Toggle floating |
| `Super + F` | Toggle fullscreen |
| `Super + P` | Pseudo tile (dwindle) |
| `Super + J` | Toggle split (dwindle) |

### System

| Keybinding | Action |
|------------|--------|
| `Super + L` | Lock screen |
| `Super + Shift + Q` | Logout menu (wlogout) |
| `Super + Shift + P` | Power menu |
| `Super + X` | WiFi menu |
| `Super + B` | Bluetooth menu |
| `Super + M` | Monitor layout menu |
| `Alt + F4` | Logout menu |

### Clipboard & Utils

| Keybinding | Action |
|------------|--------|
| `Super + C` | Clipboard history (basic) |
| `Super + Shift + C` | Enhanced clipboard manager |
| `Super + Period` | Emoji picker |
| `Super + Ctrl + Space` | Change wallpaper |
| `Super + Ctrl + B` | Reload waybar |

### Screenshots

| Keybinding | Action |
|------------|--------|
| `Super + F12` | Screenshot region |
| `Super + Shift + F12` | Screenshot full |

### Night Mode (hyprsunset)

| Keybinding | Action |
|------------|--------|
| `Super + N` | Night mode (4200K) |
| `Super + Shift + N` | Extra warm (3800K) |
| `Super + Ctrl + N` | Day mode (6500K) |
| `Super + Alt + N` | Disable hyprsunset |

### Workspaces

| Keybinding | Action |
|------------|--------|
| `Super + 1-0` | Switch workspace |
| `Super + Shift + 1-0` | Move to workspace |
| `Super + S` | Toggle scratchpad |
| `Super + Shift + S` | Move to scratchpad |
| `Super + Scroll` | Switch workspaces |

### Mouse

| Action | Binding |
|--------|---------|
| Move window | `Super + Left Click` |
| Resize window | `Super + Right Click` |
| Switch workspace | `Super + Scroll` |

## 🔧 Scripts

| Script | Description |
|--------|-------------|
| `install.sh` | Full installation script |
| `uninstall.sh` | Remove all symlinks and restore backups |
| `update.sh` | Pull updates and reload configs |
| `check-config.sh` | Verify configuration health |
| `swww-wallpaper.sh` | Change wallpaper with colors |
| `download-wallpapers.sh` | Download starter wallpapers |
| `generate-keybindings.sh` | Generate keybindings reference |
| `hyprsunset-apply` | Apply blue light filter |
| `hyprsunset-off` | Disable blue light filter |
| `wlogout-launch` | Launch logout menu |
| `clipboard-manager` | Enhanced clipboard with search & persistence |
| `rofi-wifi` | WiFi network selector |
| `rofi-bluetooth` | Bluetooth device manager |
| `rofi-power` | Power options menu |
| `theme-switcher` | Toggle between light/dark themes |
| `monitor-layout` | Save/restore monitor configurations |
| `dotfiles-backup` | Auto-backup to git |

## 🎨 Theming

Colors are automatically extracted from your wallpaper using `wallust`. The following applications are themed:

- Hyprland (borders, active window)
- Waybar
- Rofi
- Kitty
- SwayNC

### Manual Theme Switching

```bash
# Toggle between light and dark
theme-switcher toggle

# Or use make
make theme-toggle
make theme-light
make theme-dark
```

To change wallpaper and colors:
```bash
Super + Ctrl + Space
```

## 📝 Directory Structure

```
dots/
├── hypr/              # Hyprland, hyprlock, hypridle configs
├── fish/              # Fish shell config
├── kitty/             # Kitty terminal config
├── rofi/              # Rofi launcher themes
├── waybar/            # Status bar config and scripts
├── swaync/            # Notification daemon config
├── wlogout/           # Logout menu config
├── wallust/           # Color generation templates
├── fastfetch/         # System info config
├── rofimoji/          # Emoji picker config
├── scripts/           # Utility scripts
├── systemd/           # User services
├── templates/         # Template files (secrets, etc.)
├── sugar-candy/       # SDDM theme
├── Wallpapers5/       # Wallpapers directory
├── install.sh         # Main installer
├── uninstall.sh       # Uninstaller
├── update.sh          # Update script
├── check-config.sh    # Config validator
├── Makefile           # Convenient commands
├── README.md          # This file
└── LICENSE            # MIT License
```

## 🛠️ Makefile Commands

Use `make` for common tasks:

```bash
make help           # Show all available commands
make install        # Install dotfiles
make uninstall      # Remove dotfiles
make update         # Update from git
make backup         # Backup to git
make check          # Check config health
make theme-toggle   # Toggle light/dark theme
make wallpaper      # Change wallpaper
make clipboard      # Show clipboard history
make wifi           # WiFi menu
make bluetooth      # Bluetooth menu
make power          # Power menu
make monitors       # Monitor layout menu
make keybindings    # Generate keybindings reference
make secrets-init   # Initialize secrets management
make deps           # Check dependencies
```

## 🔄 Maintenance

### Update dotfiles
```bash
./update.sh
# Or: make update
```

### Auto-Backup Setup
```bash
# Setup daily backups
./scripts/dotfiles-backup setup daily

# Or use make
make backup-setup

# Check backup status
./scripts/dotfiles-backup status
```

### Check configuration health
```bash
./check-config.sh
# Or: make check
```

### Uninstall
```bash
./uninstall.sh
# Or: make uninstall
```

## 🔐 Secrets Management

Keep your API keys and passwords safe:

1. **Initialize secrets** (once):
   ```bash
   make secrets-init
   ```

2. **Edit secrets**:
   ```bash
   nano ~/.config/secrets.env
   ```

3. **Load secrets in fish config**:
   ```fish
   source ~/.config/secrets.env
   ```

Secrets are automatically excluded from git via `.gitignore`.

## 🐛 Troubleshooting

### Hyprland won't start
- Check if your GPU drivers are installed
- Verify `hyprland.conf` syntax: `hyprctl reload`

### Wallpapers not changing
- Ensure `swww-daemon` is running
- Check that wallpapers exist in `~/Pictures/Wallpapers5/`

### Colors not updating
- Verify `wallust` is installed
- Check `~/.cache/wallust/` exists and is writable

### Waybar not showing
- Run `waybar` from terminal to see errors
- Check if config is valid JSON

### Clipboard manager not working
- Ensure `sqlite3` is installed
- Check `~/.local/share/clipboard-history/` exists

### Rofi menus not working
- Check that scripts are executable: `chmod +x scripts/*`
- Verify `nmcli` and `bluetoothctl` are installed

## 📋 Requirements

### Core
- hyprland
- hyprlock
- hypridle
- hyprsunset

### UI
- waybar
- rofi-wayland
- swaync
- wlogout
- swww

### Terminal & Shell
- kitty
- fish
- oh-my-posh

### Utilities
- wallust
- cliphist
- wl-clipboard
- sqlite3 (for enhanced clipboard)
- jq (for monitor layouts)

### System
- brightnessctl
- playerctl
- grim
- slurp
- ranger
- nautilus
- nmcli (NetworkManager)
- bluetoothctl (bluez)

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Hyprland](https://hyprland.org/) - The compositor that makes this possible
- [Wallust](https://codeberg.org/explosion-mental/wallust) - Dynamic theming
- [Sugar Candy](https://github.com/Kangie/sddm-sugar-candy) - Beautiful SDDM theme

## 📸 Screenshots

<p align="center">
  <img src="https://raw.githubusercontent.com/mohammedbakri123/My_dots/master/Screenshot-2026-02-08_18%3A36%3A22.png" alt="Desktop Preview 1" width="100%"/>
  <br/>
  <em>Clean desktop with dynamic theming</em>
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/mohammedbakri123/My_dots/master/Screenshot-2026-02-08_18%3A38%3A46.png" alt="Desktop Preview 2" width="100%"/>
  <br/>
  <em>Application workflow and window management</em>
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/mohammedbakri123/My_dots/master/Screenshot-2026-02-08_18%3A39%3A25.png" alt="Desktop Preview 3" width="100%"/>
  <br/>
  <em>Rofi launcher and system menus</em>
</p>

---

Made with ❤️ by [Mohammed Bakri]

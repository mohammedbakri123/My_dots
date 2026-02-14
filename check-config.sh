#!/bin/bash
# Check for missing or incomplete configurations

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

CONFIG_DIR="$HOME/.config"

print_ok() { echo -e "${GREEN}✓${NC} $1"; }
print_missing() { echo -e "${RED}✗${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }

echo "Checking dotfiles configuration..."
echo

# Check if configs exist
check_config() {
    local name="$1"
    local path="$2"
    
    if [ -e "$path" ]; then
        if [ -L "$path" ]; then
            print_ok "$name is symlinked"
        else
            print_warning "$name exists but is not a symlink"
        fi
    else
        print_missing "$name is missing"
    fi
}

echo "=== Configuration Files ==="
check_config "Hyprland" "$CONFIG_DIR/hypr"
check_config "Fish" "$CONFIG_DIR/fish"
check_config "Rofi" "$CONFIG_DIR/rofi"
check_config "Waybar" "$CONFIG_DIR/waybar"
check_config "SwayNC" "$CONFIG_DIR/swaync"
check_config "wlogout" "$CONFIG_DIR/wlogout"
check_config "Fastfetch" "$CONFIG_DIR/fastfetch"
check_config "Wallust" "$CONFIG_DIR/wallust"
check_config "Rofimoji" "$CONFIG_DIR/rofimoji"

echo
echo "=== Missing Common Configs ==="

# Check for kitty config
if [ ! -e "$CONFIG_DIR/kitty" ]; then
    print_missing "Kitty config (optional but recommended)"
fi

# Check for dunst or mako
if [ ! -e "$CONFIG_DIR/dunst" ] && [ ! -e "$CONFIG_DIR/mako" ]; then
    print_missing "Notification daemon config (dunst/mako)"
fi

# Check for gtk theme
if [ ! -e "$HOME/.themes" ]; then
    print_warning "GTK themes directory missing"
fi

# Check for icon theme
if [ ! -e "$HOME/.icons" ] && [ ! -d "/usr/share/icons/Papirus" ]; then
    print_warning "Icon theme may be missing (recommend: Papirus)"
fi

echo
echo "=== Dependencies ==="

deps=(hyprland waybar rofi fish swww kitty wallust)
for dep in "${deps[@]}"; do
    if command -v "$dep" &> /dev/null; then
        print_ok "$dep installed"
    else
        print_missing "$dep not found"
    fi
done

echo
echo "=== Directories ==="

if [ -d "$HOME/Pictures/Wallpapers5" ]; then
    count=$(ls -1 "$HOME/Pictures/Wallpapers5" 2>/dev/null | wc -l)
    if [ "$count" -gt 0 ]; then
        print_ok "Wallpapers directory ($count wallpapers)"
    else
        print_warning "Wallpapers directory is empty"
    fi
else
    print_missing "Wallpapers directory (~/Pictures/Wallpapers5)"
fi

if [ -d "$HOME/.local/bin" ]; then
    print_ok "~/.local/bin exists"
else
    print_missing "~/.local/bin"
fi

echo
echo "=== Recommendations ==="
echo "• Add wallpapers to ~/Pictures/Wallpapers5/"
echo "• Install icon theme: papirus-icon-theme"
echo "• Install cursor theme: bibata-cursor-theme"
echo "• Set fish as default shell: chsh -s /usr/bin/fish"

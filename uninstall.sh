#!/bin/bash
set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

DOTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
LOCAL_BIN="$HOME/.local/bin"

print_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

uninstall_configs() {
    print_info "Removing config symlinks..."
    
    local configs=(hypr fish rofi waybar swaync wlogout fastfetch wallust rofimoji)
    
    for config in "${configs[@]}"; do
        local link="$CONFIG_DIR/$config"
        if [ -L "$link" ]; then
            rm "$link"
            print_info "Removed symlink: $link"
            
            # Restore backup if exists
            local backup=$(ls -d "${link}.backup."* 2>/dev/null | sort -V | tail -n1)
            if [ -n "$backup" ]; then
                mv "$backup" "$link"
                print_info "Restored backup: $backup → $link"
            fi
        fi
    done
}

uninstall_scripts() {
    print_info "Removing installed scripts..."
    
    for script in "$DOTS_DIR"/scripts/*; do
        if [ -f "$script" ]; then
            local script_name=$(basename "$script")
            if [ -f "$LOCAL_BIN/$script_name" ]; then
                rm "$LOCAL_BIN/$script_name"
                print_info "Removed: $LOCAL_BIN/$script_name"
            fi
        fi
    done
    
    for script in "$DOTS_DIR"/waybar/scripts/*.sh; do
        if [ -f "$script" ]; then
            local script_name=$(basename "$script")
            if [ -f "$LOCAL_BIN/$script_name" ]; then
                rm "$LOCAL_BIN/$script_name"
                print_info "Removed: $LOCAL_BIN/$script_name"
            fi
        fi
    done
}

uninstall_sddm() {
    print_info "Removing SDDM theme..."
    
    if [ -d "/usr/share/sddm/themes/sugar-candy" ]; then
        sudo rm -rf /usr/share/sddm/themes/sugar-candy
        print_info "Removed SDDM theme"
    fi
}

uninstall_systemd() {
    print_info "Removing systemd user services..."
    
    local services=(hyprland-session waybar swaync swww)
    
    for service in "${services[@]}"; do
        local service_file="$HOME/.config/systemd/user/${service}.service"
        if [ -f "$service_file" ]; then
            systemctl --user stop "$service" 2>/dev/null || true
            systemctl --user disable "$service" 2>/dev/null || true
            rm "$service_file"
            print_info "Removed service: $service"
        fi
    done
    
    # Remove systemd directory if empty
    if [ -d "$HOME/.config/systemd/user" ]; then
        rmdir "$HOME/.config/systemd/user" 2>/dev/null || true
        rmdir "$HOME/.config/systemd" 2>/dev/null || true
    fi
    
    systemctl --user daemon-reload 2>/dev/null || true
}

main() {
    echo -e "${RED}═══════════════════════════════════════════════════════════${NC}"
    echo "  Hyprland Dotfiles Uninstaller"
    echo -e "${RED}═══════════════════════════════════════════════════════════${NC}"
    echo
    
    read -p "This will remove all symlinks and restore backups. Continue? [y/N] " confirm
    
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        print_info "Cancelled"
        exit 0
    fi
    
    uninstall_systemd
    uninstall_configs
    uninstall_scripts
    uninstall_sddm
    
    echo
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    print_info "Uninstall complete!"
    print_info "Note: TLP config and installed packages were not removed"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
}

main "$@"

#!/bin/bash
set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

DOTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }

update_repo() {
    print_info "Pulling latest changes..."
    
    cd "$DOTS_DIR"
    
    if [ -d ".git" ]; then
        git pull origin $(git branch --show-current)
        print_success "Repository updated"
    else
        print_warning "Not a git repository, skipping git pull"
    fi
}

reload_configs() {
    print_info "Reloading configurations..."
    
    # Reload hyprland
    if command -v hyprctl &> /dev/null; then
        hyprctl reload 2>/dev/null && print_success "Hyprland reloaded" || print_warning "Failed to reload Hyprland"
    fi
    
    # Reload waybar
    if pgrep waybar &> /dev/null; then
        pkill waybar && waybar &
        print_success "Waybar reloaded"
    fi
    
    # Reload swaync
    if pgrep swaync &> /dev/null; then
        swaync-client -rs 2>/dev/null && print_success "Swaync reloaded" || print_warning "Failed to reload swaync"
    fi
}

main() {
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    echo "  Hyprland Dotfiles Updater"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    echo
    
    update_repo
    reload_configs
    
    echo
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    print_success "Update complete!"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
}

main "$@"

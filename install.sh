#!/bin/bash
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

DOTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
LOCAL_BIN="$HOME/.local/bin"

# Dependencies
PACMAN_PKGS=(
    hyprland hyprlock hypridle hyprsunset
    waybar swaync wlogout
    rofi-wayland
    fish
    swww
    kitty
    wallust
    cliphist
    wl-clipboard
    brightnessctl
    playerctl
    grim slurp
    nautilus
    ranger
    dunst
    tlp
    sddm
    qt6-svg qt6-declarative
)

AUR_PKGS=(
    rofimoji
    oh-my-posh-bin
)

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_command() {
    command -v "$1" &> /dev/null
}

detect_distro() {
    if [ -f /etc/arch-release ]; then
        echo "arch"
    elif [ -f /etc/fedora-release ]; then
        echo "fedora"
    else
        echo "unknown"
    fi
}

install_packages() {
    local distro=$(detect_distro)
    
    if [ "$distro" = "arch" ]; then
        print_info "Installing packages via pacman..."
        sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}" || {
            print_warning "Some pacman packages failed to install"
        }
        
        # Check for AUR helper
        if check_command yay; then
            print_info "Installing AUR packages via yay..."
            yay -S --needed --noconfirm "${AUR_PKGS[@]}" || {
                print_warning "Some AUR packages failed to install"
            }
        elif check_command paru; then
            print_info "Installing AUR packages via paru..."
            paru -S --needed --noconfirm "${AUR_PKGS[@]}" || {
                print_warning "Some AUR packages failed to install"
            }
        else
            print_warning "No AUR helper found. Please install yay or paru for AUR packages:"
            print_warning "  - rofimoji"
            print_warning "  - oh-my-posh-bin"
        fi
    else
        print_warning "Automatic package installation only supported on Arch Linux"
        print_warning "Please install the following packages manually:"
        printf '%s\n' "${PACMAN_PKGS[@]}"
        printf '%s\n' "${AUR_PKGS[@]}"
    fi
}

backup_config() {
    local config_path="$1"
    if [ -e "$config_path" ] && [ ! -L "$config_path" ]; then
        local backup_path="${config_path}.backup.$(date +%Y%m%d_%H%M%S)"
        print_warning "Backing up $config_path to $backup_path"
        mv "$config_path" "$backup_path"
    fi
}

link_config() {
    local src="$1"
    local dest="$2"
    
    backup_config "$dest"
    
    if [ -L "$dest" ]; then
        rm "$dest"
    fi
    
    ln -sf "$src" "$dest"
    print_success "Linked $src → $dest"
}

setup_configs() {
    print_info "Setting up configuration directories..."
    
    mkdir -p "$CONFIG_DIR"
    mkdir -p "$LOCAL_BIN"
    mkdir -p "$HOME/Pictures/Wallpapers5"
    mkdir -p "$HOME/Pictures/Screenshots"
    mkdir -p "$HOME/.local/share/clipboard-history"
    
    # Link config directories
    local configs=(hypr fish rofi waybar swaync wlogout fastfetch wallust rofimoji kitty)
    
    for config in "${configs[@]}"; do
        if [ -d "$DOTS_DIR/$config" ]; then
            link_config "$DOTS_DIR/$config" "$CONFIG_DIR/$config"
        fi
    done
    
    # Create templates directory if not exists
    mkdir -p "$DOTS_DIR/templates"
}

setup_scripts() {
    print_info "Setting up scripts..."
    
    # Make scripts executable and copy to ~/.local/bin
    for script in "$DOTS_DIR"/scripts/*; do
        if [ -f "$script" ]; then
            chmod +x "$script"
            cp -f "$script" "$LOCAL_BIN/"
            print_success "Installed script: $(basename "$script")"
        fi
    done
    
    # Also copy waybar scripts
    for script in "$DOTS_DIR"/waybar/scripts/*.sh; do
        if [ -f "$script" ]; then
            chmod +x "$script"
            cp -f "$script" "$LOCAL_BIN/"
            print_success "Installed script: $(basename "$script")"
        fi
    done
}

setup_sddm() {
    print_info "Setting up SDDM theme..."
    
    if [ -d "$DOTS_DIR/sugar-candy" ]; then
        sudo mkdir -p /usr/share/sddm/themes/
        sudo cp -r "$DOTS_DIR/sugar-candy" /usr/share/sddm/themes/
        print_success "Installed SDDM theme"
    fi
    
    if [ -f "$DOTS_DIR/sddm.conf" ]; then
        sudo cp "$DOTS_DIR/sddm.conf" /etc/sddm.conf
        print_success "Installed SDDM config"
    fi
}

setup_tlp() {
    print_info "Setting up TLP..."
    
    if [ -f "$DOTS_DIR/tlp.conf" ]; then
        sudo cp "$DOTS_DIR/tlp.conf" /etc/tlp.conf
        print_success "Installed TLP config"
        print_info "Enable TLP with: sudo systemctl enable --now tlp"
    fi
}

set_shell() {
    print_info "Setting up Fish shell..."
    
    if check_command fish; then
        # Add fish to /etc/shells if not present
        if ! grep -q "$(which fish)" /etc/shells 2>/dev/null; then
            echo "$(which fish)" | sudo tee -a /etc/shells > /dev/null
        fi
        
        print_info "To set fish as your default shell, run:"
        print_info "  chsh -s $(which fish)"
    fi
}

setup_systemd() {
    print_info "Setting up systemd user services..."
    
    mkdir -p "$CONFIG_DIR/systemd/user"
    
    for service in "$DOTS_DIR"/systemd/user/*.service; do
        if [ -f "$service" ]; then
            cp -f "$service" "$CONFIG_DIR/systemd/user/"
            print_success "Installed service: $(basename "$service")"
        fi
    done
    
    systemctl --user daemon-reload 2>/dev/null || true
}

create_cache_dirs() {
    print_info "Creating cache directories..."
    mkdir -p "$HOME/.cache/wallust"
}

main() {
    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║        Hyprland Dotfiles Setup Script                    ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    print_info "Dotfiles location: $DOTS_DIR"
    
    # Ask user what to do
    echo
    echo "What would you like to do?"
    echo "  1) Full setup (install packages + configs)"
    echo "  2) Install packages only"
    echo "  3) Setup configs only (no package install)"
    echo "  4) Exit"
    read -p "Enter choice [1-4]: " choice
    
    case $choice in
        1)
            install_packages
            setup_configs
            setup_scripts
            setup_sddm
            setup_tlp
            set_shell
            setup_systemd
            create_cache_dirs
            ;;
        2)
            install_packages
            ;;
        3)
            setup_configs
            setup_scripts
            setup_sddm
            setup_tlp
            set_shell
            setup_systemd
            create_cache_dirs
            ;;
        4)
            print_info "Exiting..."
            exit 0
            ;;
        *)
            print_error "Invalid choice"
            exit 1
            ;;
    esac
    
    echo
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    print_success "Setup complete!"
    echo
    print_info "Next steps:"
    print_info "  1. Set fish as default shell: chsh -s $(which fish 2>/dev/null || echo '/usr/bin/fish')"
    print_info "  2. Add wallpapers to: ~/Pictures/Wallpapers5/"
    print_info "  3. Reboot or log out and back in"
    print_info "  4. Enable services:"
    print_info "     - sudo systemctl enable --now sddm"
    print_info "     - sudo systemctl enable --now tlp"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
}

main "$@"

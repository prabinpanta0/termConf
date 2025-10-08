#!/bin/bash
set -e  # Exit on error

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# Print functions
print_header() {
    echo -e "${BOLD}${CYAN}=== $1 ===${RESET}"
}

print_success() {
    echo -e "${GREEN}✓${RESET} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${RESET} $1"
}

print_error() {
    echo -e "${RED}✗${RESET} $1"
}

print_info() {
    echo -e "${BLUE}→${RESET} $1"
}

print_header "Terminal Configuration Installer"
echo

# Detect OS and set package manager
print_info "Detecting operating system..."
if [ -f /etc/debian_version ]; then
    OS="debian"
    PM_INSTALL="sudo apt install -y"
    PM_UPDATE="sudo apt update && sudo apt upgrade -y"
    FONT_PKG="fonts-jetbrains-mono"
    FETCH_PKG="neofetch"
elif [ -f /etc/arch-release ]; then
    OS="arch"
    PM_INSTALL="sudo pacman -S --noconfirm"
    PM_UPDATE="sudo pacman -Syu --noconfirm"
    FONT_PKG="ttf-jetbrains-mono"
    FETCH_PKG="fastfetch"  # neofetch is deprecated on Arch
elif [ -f /etc/fedora-release ]; then
    OS="fedora"
    PM_INSTALL="sudo dnf install -y"
    PM_UPDATE="sudo dnf upgrade --refresh -y"
    FONT_PKG="jetbrains-mono-fonts"
    FETCH_PKG="neofetch"
else
    print_error "Unsupported OS. This script supports Debian-based, Arch-based, and Fedora-based distributions."
    exit 1
fi

print_success "Detected OS: ${BOLD}$OS${RESET}"
echo

# Update system
print_header "Updating system packages"
$PM_UPDATE
print_success "System updated"
echo

# Install core packages
print_header "Installing core packages"
print_info "Installing: fish, kitty, $FONT_PKG, doas, $FETCH_PKG"
$PM_INSTALL fish kitty $FONT_PKG doas $FETCH_PKG
print_success "Core packages installed"
echo

# Install uv (Python package manager)
print_header "Installing uv"
if ! command -v uv &> /dev/null; then
    print_info "Downloading and installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.cargo/bin:$PATH"
    print_success "uv installed successfully"
else
    print_warning "uv is already installed"
fi
echo

# Install thefuck
print_header "Installing thefuck"
if ! command -v thefuck &> /dev/null; then
    if command -v pip3 &> /dev/null; then
        print_info "Installing thefuck via pip3..."
        pip3 install --user thefuck
        print_success "thefuck installed successfully"
    elif command -v pip &> /dev/null; then
        print_info "Installing thefuck via pip..."
        pip install --user thefuck
        print_success "thefuck installed successfully"
    else
        print_warning "pip not found. Skipping thefuck installation."
        print_info "You can install it later with: pip3 install --user thefuck"
    fi
else
    print_warning "thefuck is already installed"
fi
echo

# Copy configuration files
print_header "Installing configuration files"
mkdir -p ~/.config/fish
mkdir -p ~/.config/kitty
mkdir -p ~/.config/neofetch

print_info "Copying fish config..."
cp -r fish/* ~/.config/fish/
print_success "Fish config installed"

print_info "Copying kitty config..."
cp -r kitty/* ~/.config/kitty/
print_success "Kitty config installed"

print_info "Copying neofetch config..."
cp -r neofetch/* ~/.config/neofetch/
print_success "Neofetch config installed"
echo

# Configure doas
print_header "Configuring doas"
print_info "Setting up doas permissions..."
sudo cp doas.conf /etc/doas.conf
sudo chown -c root:root /etc/doas.conf
sudo chmod -c 0600 /etc/doas.conf
print_success "doas.conf installed with correct permissions"

# Add user to wheel group if not already in it
if ! groups | grep -q wheel; then
    print_info "Adding user to wheel group..."
    sudo usermod -aG wheel $USER
    print_warning "You need to log out and back in for wheel group membership to take effect"
else
    print_success "User is already in wheel group"
fi
echo

# Set fish as default shell
print_header "Setting fish as default shell"
FISH_PATH=$(which fish)
print_info "Fish path: $FISH_PATH"

if ! grep -q "^$FISH_PATH$" /etc/shells 2>/dev/null; then
    print_info "Adding fish to /etc/shells..."
    echo "$FISH_PATH" | sudo tee -a /etc/shells > /dev/null
    print_success "Fish added to /etc/shells"
fi

# Check if fish is already the default shell
CURRENT_SHELL=$(getent passwd $USER | cut -d: -f7)
if [ "$CURRENT_SHELL" != "$FISH_PATH" ]; then
    print_info "Changing default shell to fish..."
    if chsh -s "$FISH_PATH"; then
        print_success "Default shell set to fish"
    else
        print_warning "Failed to change shell. You may need to run: chsh -s $FISH_PATH"
    fi
else
    print_success "Fish is already your default shell"
fi
echo

# Add to .profile for login shells
if ! grep -q "export SHELL=" ~/.profile 2>/dev/null; then
    echo "export SHELL=$FISH_PATH" >> ~/.profile
    print_success "Updated ~/.profile"
fi

print_header "Installation complete!"
echo
echo -e "${GREEN}✓${RESET} All configurations installed successfully!"
echo
echo -e "${BOLD}${YELLOW}Next steps:${RESET}"
echo -e "  ${MAGENTA}1.${RESET} Log out and log back in for shell changes to take effect"
echo -e "  ${MAGENTA}2.${RESET} Open kitty terminal to use your new configuration"
if [ "$OS" = "arch" ]; then
    echo -e "  ${MAGENTA}3.${RESET} Run ${CYAN}'fastfetch'${RESET} to see your system info (neofetch successor)"
else
    echo -e "  ${MAGENTA}3.${RESET} Run ${CYAN}'neofetch'${RESET} to see your system info"
fi
echo
echo -e "${BLUE}Note:${RESET} If you're currently in bash, run ${CYAN}'exec fish'${RESET} to switch to fish immediately."
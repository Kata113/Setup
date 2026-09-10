#!/usr/bin/env bash

set -e

echo "========================================"
echo "  Arch / CachyOS Application Installer"
echo "========================================"

# --------------------------------------------------
# Check root
# --------------------------------------------------
if [[ $EUID -eq 0 ]]; then
    echo "❌ Do NOT run this script as root."
    echo "Run: ./install.sh"
    exit 1
fi

# --------------------------------------------------
# Update package database + system
# --------------------------------------------------
echo
echo "==> Updating system..."
sudo pacman -Syu --noconfirm

# --------------------------------------------------
# Install required packages
# --------------------------------------------------
echo
echo "==> Installing required packages..."

sudo pacman -S --needed --noconfirm \
    base-devel \
    git \
    flatpak

# --------------------------------------------------
# Install yay
# --------------------------------------------------
if ! command -v yay &>/dev/null; then
    echo
    echo "==> Installing yay..."

    TMP_DIR="$(mktemp -d)"

    git clone https://aur.archlinux.org/yay.git "$TMP_DIR/yay"

    cd "$TMP_DIR/yay"
    makepkg -si --noconfirm

    cd /
    rm -rf "$TMP_DIR"

    echo "==> yay installed."
else
    echo
    echo "==> yay already installed."
fi

# --------------------------------------------------
# Setup Flathub
# --------------------------------------------------
echo
echo "==> Setting up Flathub..."

if ! flatpak remote-list | grep -q "^flathub"; then
    flatpak remote-add --if-not-exists \
        flathub \
        https://flathub.org/repo/flathub.flatpakrepo
fi

# --------------------------------------------------
# AUR packages
# --------------------------------------------------
echo
echo "========================================"
echo "  Installing AUR packages"
echo "========================================"

AUR_PACKAGES=(
    google-chrome
    discord
    antigravity
    obs-studio
    steam
    intel-media-driver
    libva-intel-driver
    libva-utils
    v4l2loopback-dkms
)

yay -S --needed --noconfirm "${AUR_PACKAGES[@]}"

# --------------------------------------------------
# Flatpak packages
# --------------------------------------------------
echo
echo "========================================"
echo "  Installing Flatpak packages"
echo "========================================"

FLATPAK_PACKAGES=(
    org.vinegarhq.Sober
    org.prismlauncher.PrismLauncher
    com.vysp3r.ProtonPlus
    net.lutris.Lutris
    io.mrarm.mcpelauncher
)

flatpak install -y flathub "${FLATPAK_PACKAGES[@]}"

# --------------------------------------------------
# Cleanup
# --------------------------------------------------
echo
echo "========================================"
echo "  Cleaning up"
echo "========================================"

# Remove unused/orphan packages
yay -Yc --noconfirm || true

# Clean yay cache
yay -Sc --noconfirm || true

# Clean ALL pacman package cache
sudo pacman -Scc --noconfirm

# Clean unused Flatpak runtimes
flatpak uninstall --unused -y || true

# --------------------------------------------------
# Finish
# --------------------------------------------------
echo
echo "========================================"
echo "  Installation Complete!"
echo "========================================"

echo
echo "Installed AUR:"
printf '  - %s\n' "${AUR_PACKAGES[@]}"

echo
echo "Installed Flatpak:"
printf '  - %s\n' "${FLATPAK_PACKAGES[@]}"

echo
echo "✅ Done."
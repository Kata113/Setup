# Setup Script

One-command setup script for Arch Linux installation,I created this repository for personal use, but if anyone comes across this, you're welcome to use it :3

🚀 Install

curl -fsSL https://raw.githubusercontent.com/USERNAME/setup/main/install.sh | bash

The script will automatically:

- Update the system
- Install "yay"
- Install Flatpak + Flathub
- Install AUR packages
- Install Flatpak applications
- Clean package cache and unused packages

📦 AUR

- Google Chrome
- Discord
- Antigravity
- OBS Studio
- Steam
- Intel VA-API
- V4L2Loopback

📦 Flatpak

- Sober
- Prism Launcher
- ProtonPlus
- Lutris
- Minecraft Bedrock Launcher

🧹 Cleanup

After installation, the script cleans:

- Pacman cache
- Yay cache
- Unused/orphan packages
- Unused Flatpak runtimes

⚠️ Requirements

- CachyOS / Arch Linux
- Internet connection
- A user account with "sudo" access

Do not run the script as root.
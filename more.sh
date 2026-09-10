#!/usr/bin/env bash

set -e

CONFIG="$HOME/.config/hypr"

echo "==> Setting up Hyprland..."

# Backup config
cp -r "$CONFIG" "$CONFIG.backup.$(date +%Y%m%d-%H%M%S)"

# Keyboard
cat >> "$CONFIG/hyprland.conf" <<'EOF'

# Custom keyboard
input {
    kb_layout = us,th
    kb_options = grp:win_space_toggle
}

# Custom keybinds
bind = , HOME, exec, walker
EOF

echo "✓ Hyprland setup complete!"
echo "✓ Super + Space  → Switch Thai / English"
echo "✓ Home            → Application Launcher"
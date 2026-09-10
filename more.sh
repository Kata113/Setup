#!/usr/bin/env bash
set -e

HYPR_DIR="$HOME/.config/hypr/config"
INPUTS="$HYPR_DIR/inputs.lua"
BINDS="$HYPR_DIR/binds.lua"

# Backup
cp "$INPUTS" "$INPUTS.bak"
cp "$BINDS" "$BINDS.bak"

# English <-> Thai with Super + Space
cat >> "$INPUTS" <<'EOF'

hl.config({
    input = {
        kb_layout = "us,th",
        kb_options = "grp:win_space_toggle"
    }
})
EOF

# Move the existing CachyOS launcher from Super+Space to Home
sed -i 's/hl\.bind(mainMod \.\. " + Space"/hl.bind("Home"/g' "$BINDS"

# Reload
hyprctl reload

echo "Done!"
echo "Super + Space = English / Thai"
echo "Home = Application Launcher"
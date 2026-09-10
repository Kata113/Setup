#!/usr/bin/env bash
set -euo pipefail

HYPR_DIR="$HOME/.config/hypr/config"
INPUTS="$HYPR_DIR/inputs.lua"
BINDS="$HYPR_DIR/binds.lua"

mkdir -p "$HYPR_DIR"

# Backup
timestamp="$(date +%Y%m%d-%H%M%S)"

[[ -f "$INPUTS" ]] && cp "$INPUTS" "$INPUTS.bak-$timestamp"
[[ -f "$BINDS" ]] && cp "$BINDS" "$BINDS.bak-$timestamp"

# --------------------------------------------------
# Keyboard layout: English <-> Thai with Super+Space
# --------------------------------------------------

if [[ -f "$INPUTS" ]]; then
    if ! grep -q 'kb_layout.*us,th' "$INPUTS"; then
        cat >> "$INPUTS" <<'EOF'

-- Custom keyboard layout
hl.config({
    input = {
        kb_layout = "us,th",
        kb_options = "grp:win_space_toggle"
    }
})
EOF
    fi
else
    cat > "$INPUTS" <<'EOF'
-- Custom keyboard layout
hl.config({
    input = {
        kb_layout = "us,th",
        kb_options = "grp:win_space_toggle"
    }
})
EOF
fi

# --------------------------------------------------
# Keybinds
# --------------------------------------------------

if [[ -f "$BINDS" ]]; then
    # Remove existing Super+Space binding if present
    sed -i '/SUPER *+ *SPACE.*walker/d' "$BINDS"
    sed -i '/SUPER *+ *SPACE.*launcher/d' "$BINDS"

    # Remove an old HOME custom binding
    sed -i '/HOME.*walker/d' "$BINDS"

    cat >> "$BINDS" <<'EOF'

-- Custom keybinds
-- Super + Space is reserved for keyboard layout switching
hl.unbind("SUPER + SPACE")

-- Home opens application launcher
hl.bind("HOME", hl.dsp.exec_cmd("walker"))
EOF
else
    cat > "$BINDS" <<'EOF'
-- Custom keybinds
hl.unbind("SUPER + SPACE")
hl.bind("HOME", hl.dsp.exec_cmd("walker"))
EOF
fi

echo "Hyprland configuration updated."
echo "Backups created with timestamp: $timestamp"
echo
echo "Keyboard: Super + Space = English/Thai"
echo "Launcher: Home = Walker"

# Reload Hyprland
hyprctl reload
#!/usr/bin/env bash

set -e

HYPR="$HOME/.config/hypr"
BACKUP="$HYPR/setup-backup-$(date +%Y%m%d-%H%M%S)"

echo "==> Hyprland custom setup"

# --------------------------------------------------
# Find CachyOS Hyprland config files
# --------------------------------------------------

INPUT=""
BINDS=""

for f in \
    "$HYPR/config/input.lua" \
    "$HYPR/config/inputs.lua" \
    "$HYPR/input.lua" \
    "$HYPR/inputs.lua"
do
    [[ -f "$f" ]] && INPUT="$f" && break
done

for f in \
    "$HYPR/config/binds.lua" \
    "$HYPR/binds.lua"
do
    [[ -f "$f" ]] && BINDS="$f" && break
done

if [[ -z "$INPUT" || -z "$BINDS" ]]; then
    echo "❌ Could not find CachyOS Hyprland input/binds config."
    echo
    echo "Input: $INPUT"
    echo "Binds: $BINDS"
    exit 1
fi

echo "✓ Input config: $INPUT"
echo "✓ Binds config: $BINDS"

# --------------------------------------------------
# Backup
# --------------------------------------------------

mkdir -p "$BACKUP"

cp "$INPUT" "$BACKUP/"
cp "$BINDS" "$BACKUP/"

echo "✓ Backup created: $BACKUP"

# --------------------------------------------------
# Keyboard layout
# --------------------------------------------------

python - "$INPUT" <<'PY'
import sys
from pathlib import Path

p = Path(sys.argv[1])
s = p.read_text()

# Remove previous settings made by this script
lines = s.splitlines()
out = []

for line in lines:
    if "# Kata Setup: keyboard" in line:
        continue
    if "kb_layout = \"us,th\"" in line:
        continue
    if "kb_options = \"grp:win_space_toggle\"" in line:
        continue
    out.append(line)

out += [
    "",
    "# Kata Setup: keyboard",
    'kb_layout = "us,th"',
    'kb_options = "grp:win_space_toggle"',
]

p.write_text("\n".join(out) + "\n")
PY

# --------------------------------------------------
# Keybinds
# --------------------------------------------------

python - "$BINDS" <<'PY'
import sys
from pathlib import Path

p = Path(sys.argv[1])
s = p.read_text()

lines = s.splitlines()
out = []

for line in lines:
    # Remove the old Super + Space launcher bind
    if "SUPER + Space" in line or "$mainMod + Space" in line:
        continue

    # Remove previous Home bind made by this script
    if "# Kata Setup: launcher" in line:
        continue
    if "HOME" in line and "walker" in line:
        continue

    out.append(line)

out += [
    "",
    "# Kata Setup: launcher",
    'hl.bind("HOME", hl.exec_cmd("walker"))',
]

p.write_text("\n".join(out) + "\n")
PY

echo "✓ Keyboard layout configured"
echo "✓ Super + Space → Thai / English"
echo "✓ Home → Application Launcher"

# --------------------------------------------------
# Reload Hyprland
# --------------------------------------------------

if command -v hyprctl >/dev/null 2>&1 && [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
    echo "==> Reloading Hyprland..."
    hyprctl reload
    echo "✓ Hyprland reloaded"
else
    echo
    echo "ℹ Restart Hyprland to apply the changes."
fi

echo
echo "========================================"
echo " Hyprland setup complete!"
echo "========================================"
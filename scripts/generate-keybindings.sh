#!/bin/bash
# Generate keybindings cheat sheet from hyprland.conf

HYPR_CONF="$HOME/.config/hypr/hyprland.conf"
OUTPUT="$HOME/.config/hypr/KEYBINDINGS.md"

if [ ! -f "$HYPR_CONF" ]; then
    echo "Error: hyprland.conf not found at $HYPR_CONF"
    exit 1
fi

cat > "$OUTPUT" << 'EOF'
# Hyprland Keybindings

> Auto-generated from hyprland.conf

## Modifier Key
- **$mainMod** = SUPER (Windows key)

## Application Launchers

| Keybinding | Action |
|------------|--------|
EOF

# Extract keybindings
grep "^bind = " "$HYPR_CONF" | grep -v "bindm" | while read -r line; do
    # Parse bind lines
    key=$(echo "$line" | sed 's/bind = //' | cut -d',' -f2 | xargs)
    mod=$(echo "$line" | sed 's/bind = //' | cut -d',' -f1 | xargs)
    action=$(echo "$line" | sed 's/bind = //' | cut -d',' -f3- | xargs)
    
    # Format modifier
    if [ "$mod" = "$mainMod" ]; then
        mod_str="Super"
    else
        mod_str=$(echo "$mod" | sed 's/\$mainMod/Super/g')
    fi
    
    echo "| $mod_str + $key | $action |" >> "$OUTPUT"
done

cat >> "$OUTPUT" << 'EOF'

## Mouse Bindings

| Button | Action |
|--------|--------|
| Super + Left Click | Move window |
| Super + Right Click | Resize window |

## Workspaces

| Keybinding | Action |
|------------|--------|
| Super + [1-9,0] | Switch to workspace |
| Super + Shift + [1-9,0] | Move window to workspace |
| Super + Scroll | Switch workspaces |
EOF

echo "Keybindings reference generated at: $OUTPUT"

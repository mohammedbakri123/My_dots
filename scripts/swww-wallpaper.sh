#!/bin/bash
set -euo pipefail

WALLDIR="$HOME/Pictures/Wallpapers5"
HEX="$HOME/.cache/wallust/hyprland.hex"
CONVERTER="$HOME/.local/bin/hypr-wallust-rgba"

# ensure swww daemon is running (idempotent)
swww init 2>/dev/null || true

# pick random wallpaper
WALL=$(find "$WALLDIR" -type f \( \
  -iname "*.jpg" -o \
  -iname "*.jpeg" -o \
  -iname "*.png" -o \
  -iname "*.gif" \
\) | shuf -n 1)

[ -z "$WALL" ] && exit 1

# set wallpaper
swww img "$WALL" \
  --transition-type grow \
  --transition-duration 0.8 \
  --transition-fps 60

# generate colors
wallust run "$WALL" --backend full

# wait for wallust to write hex
for i in {1..30}; do
  [ -s "$HEX" ] && break
  sleep 0.05
done

# convert hex → rgba (absolute path!)
"$CONVERTER"

# reload UI
#hyprctl reload
#waybar
#pkill rofi
#pkill -SIGUSR2 waybar

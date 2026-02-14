#!/bin/bash
# Download starter wallpapers from various sources

WALL_DIR="$HOME/Pictures/Wallpapers5"
mkdir -p "$WALL_DIR"

echo "Downloading starter wallpapers..."

# Unsplash wallpapers (free, no API key needed for a few)
cd "$WALL_DIR"

# Download some nice wallpapers
wallpapers=(
    "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1920&q=80"
    "https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=1920&q=80"
    "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1920&q=80"
    "https://images.unsplash.com/photo-1472214103451-9374bd1c798e?w=1920&q=80"
    "https://images.unsplash.com/photo-1501854140801-50d01698950b?w=1920&q=80"
    "https://images.unsplash.com/photo-1519681393784-d120267933ba?w=1920&q=80"
    "https://images.unsplash.com/photo-1493246507139-91e8fad9978e?w=1920&q=80"
    "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=1920&q=80"
)

for i in "${!wallpapers[@]}"; do
    echo "Downloading wallpaper $((i+1))/${#wallpapers[@]}..."
    curl -L -o "wallpaper_$((i+1)).jpg" "${wallpapers[$i]}" --silent --max-time 30 || echo "Failed to download wallpaper $((i+1))"
    sleep 0.5
done

echo "Done! Wallpapers saved to: $WALL_DIR"
echo "Total wallpapers: $(ls -1 "$WALL_DIR" | wc -l)"

#!/bin/bash

# Battery percentage
BATTERY=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null)

# Power profile
PROFILE=$(powerprofilesctl get)

# Icon per power profile
case "$PROFILE" in
  performance)
    ICON="󰓅" ;;   # performance
  balanced)
    ICON="󰾅" ;;   # balanced
  power-saver)
    ICON="󰌪" ;;   # power saver
  *)
    ICON="󰁹" ;;
esac

echo "$ICON $BATTERY%"

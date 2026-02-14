#!/bin/bash

# toggle behavior
if pgrep -f "kitty.*bluetui" >/dev/null; then
  pkill -f "kitty.*bluetui"
else
  kitty --class waybar-popup --title bluetooth bluetui
fi

#!/bin/bash

# toggle behavior
if pgrep -f "kitty.*impala" >/dev/null; then
  pkill -f "kitty.*impala"
else
  kitty --class waybar-popup --title wifi impala
fi


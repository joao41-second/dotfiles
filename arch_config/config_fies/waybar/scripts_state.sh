#!/bin/bash

FILE="$HOME/.cache/waybar-scripts"

if [ -f "$FILE" ]; then
  rm -f "$FILE"
else
  mkdir -p "$HOME/.cache"
  touch "$FILE"
fi

pkill -RTMIN+8 waybar

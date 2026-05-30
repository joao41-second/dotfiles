#!/bin/bash

choice=$(echo -e "  Desligar\n  Reiniciar\n󰒲  Suspender\n󰤄  Hibernar" | wofi --dmenu \
  --prompt "Power Menu" \
  --width 250 \
  --height 200 \
  --lines 4)

case "$choice" in
  "  Desligar") systemctl poweroff ;;
  "  Reiniciar") systemctl reboot ;;
  "󰒲  Suspender") systemctl suspend ;;
  "󰤄  Hibernar") systemctl hibernate ;;
esac

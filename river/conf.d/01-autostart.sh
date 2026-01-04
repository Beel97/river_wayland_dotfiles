#!/bin/sh

# --- Aplicaciones al Inicio (Autostart) ---
riverctl spawn swww-daemon
riverctl spawn "rivertile -view-padding 5 -outer-padding 5"

if ! pgrep -x "waybar" > /dev/null; then
    riverctl spawn "waybar"
    riverctl spawn "swaync"
else
    riverctl spawn "killall -SIGUSR2 waybar"
    riverctl spawn "killall swaync && swaync"
fi

#!/bin/sh

# --- Capturas de Pantalla (grim + slurp) ---
riverctl map normal $mod P spawn 'grim -g "$(slurp)" - | wl-copy'
riverctl map normal $mod+Shift P spawn 'grim - | wl-copy'

# --- UI y Elementos Visuales ---
riverctl map normal Control+Mod1 W spawn "pkill -SIGUSR1 waybar"
riverctl map normal $mod N spawn "swaync-client -t -sw"

# -- wallpaper --
riverctl map normal $mod+Shift W spawn "alacritty --class float-alacritty -e 'wallpaper_setter'"

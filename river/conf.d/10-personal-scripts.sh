#!/bin/sh

common_scripts="$HOME/common_scripts"
launchers="$common_scripts/launchers"

# --- Lanzadores de Aplicaciones ---
riverctl map normal $mod A spawn "$launchers/w_app_launcher.sh"
riverctl map normal $mod B spawn "$launchers/w_browser_launcher.sh"
#riverctl map normal $mod+Shift W spawn "$launchers/dwm_wallpaper.sh"
riverctl map normal $mod BackSpace spawn "$launchers/w_logout_options.sh"



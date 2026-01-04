#!/bin/sh

# --- Teclas de Hardware (Audio y Brillo) ---
riverctl map normal None XF86AudioRaiseVolume spawn "amixer set Master 5%+ unmute && pkill -RTMIN+8 waybar"
riverctl map normal None XF86AudioLowerVolume spawn "amixer set Master 5%- unmute && pkill -RTMIN+8 waybar"
riverctl map normal None XF86AudioMute spawn "amixer set Master toggle && pkill -RTMIN+8 waybar"
riverctl map normal None XF86MonBrightnessUp spawn "brightnessctl set +5%"
riverctl map normal None XF86MonBrightnessDown spawn "brightnessctl set 5%-"

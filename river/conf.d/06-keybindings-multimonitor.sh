#!/bin/sh

# --- Control Multi-Monitor ---
riverctl map normal $mod BracketLeft focus-output previous
riverctl map normal $mod BracketRight focus-output next
riverctl map normal $mod+Shift BracketLeft spawn "~/.config/river/scripts/send-to-output.sh previous"
riverctl map normal $mod+Shift BracketRight spawn "~/.config/river/scripts/send-to-output.sh next"

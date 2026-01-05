#!/bin/sh

# --- Control Multi-Monitor ---
riverctl map normal $mod BracketLeft focus-output left
riverctl map normal $mod BracketRight focus-output right
riverctl map normal $mod+Shift BracketLeft spawn "~/.config/river/scripts/send-to-output.sh left"
riverctl map normal $mod+Shift BracketRight spawn "~/.config/river/scripts/send-to-output.sh right"

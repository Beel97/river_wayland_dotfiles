#!/bin/sh

# --- Variables y Configuración General ---
mod="Mod4"
term="alacritty"
file_explorer="$term -e spf"

# Carga de colores generados por matugen
if [ -f "$HOME/.config/river/matugen_colors_river.sh" ]; then
    . "$HOME/.config/river/matugen_colors_river.sh"
fi

riverctl border-width 4


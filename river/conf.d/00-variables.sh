#!/bin/sh

# --- Variables y Configuración General ---
mod="Mod4"
term="alacritty"
file_explorer="$term -e spf"

# Carga de colores y configuraciones iniciales
# This script is expected to be in the parent directory
if [ -f "$(dirname "$0")/../matugen_colors_river.sh" ]; then
    . "$(dirname "$0")/../matugen_colors_river.sh"
fi

riverctl border-width 4

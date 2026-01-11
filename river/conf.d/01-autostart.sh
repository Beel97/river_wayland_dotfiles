#!/bin/sh

# --- Aplicaciones Esenciales ---

pgrep -x kanshi >/dev/null || riverctl spawn kanshi

pgrep -x swww-daemon >/dev/null || riverctl spawn swww-daemon

pgrep -x rivertile >/dev/null || riverctl spawn "rivertile -view-padding 3 -outer-padding 5"

# --- Barras y Notificaciones (Lógica Inversa: Recargar o Iniciar) ---

pgrep -x waybar >/dev/null \
    && riverctl spawn "killall -SIGUSR2 waybar" \
    || riverctl spawn waybar

pgrep -x swaync >/dev/null \
    && riverctl spawn "swaync-client -R" \
    || riverctl spawn swaync

#!/bin/sh

# --- Controles Básicos del Gestor ---
riverctl map normal $mod T spawn "$term"
riverctl map normal $mod Q close
riverctl map normal $mod+Shift C exit

# --- Gestión de Ventanas ---
riverctl map normal $mod J focus-view next
riverctl map normal $mod K focus-view previous
riverctl map normal $mod+Shift J swap next
riverctl map normal $mod+Shift K swap previous
riverctl map normal $mod Return zoom
riverctl map normal $mod+Shift F toggle-fullscreen
riverctl map normal $mod+Shift Space toggle-float

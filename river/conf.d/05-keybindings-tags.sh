#!/bin/sh

# --- Gestión de Tags (Escritorios Virtuales) ---
for i in $(seq 1 9); do
  tags=$((1 << (i - 1)))
  riverctl map normal $mod $i set-focused-tags $tags
  riverctl map normal $mod+Shift $i set-view-tags $tags
  riverctl map normal $mod+Control $i toggle-focused-tags $tags
  riverctl map normal $mod+Shift+Control $i toggle-view-tags $tags
done

# Mapeos para ver todos los tags
riverctl map normal $mod 0 set-focused-tags 4294967295
riverctl map normal $mod+Shift 0 set-view-tags 4294967295

riverctl map normal $mod Tab focus-previous-tags

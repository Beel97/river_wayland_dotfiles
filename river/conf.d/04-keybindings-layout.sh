#!/bin/sh

# --- Gestión de Layouts (rivertile) ---
riverctl default-layout rivertile
riverctl map normal $mod H send-layout-cmd rivertile "main-ratio -0.05"
riverctl map normal $mod L send-layout-cmd rivertile "main-ratio +0.05"
riverctl map normal $mod Up send-layout-cmd rivertile "main-location top"
riverctl map normal $mod Right send-layout-cmd rivertile "main-location right"
riverctl map normal $mod Down send-layout-cmd rivertile "main-location bottom"
riverctl map normal $mod Left send-layout-cmd rivertile "main-location left"

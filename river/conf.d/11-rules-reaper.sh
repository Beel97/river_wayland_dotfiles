#!/bin/sh

# --- Reglas para REAPER (DAW) ---

# Plugins/FX - flotar
riverctl rule-add -app-id "REAPER" -title "*FX:*" float
riverctl rule-add -app-id "REAPER" -title "*VST*" float
riverctl rule-add -app-id "REAPER" -title "*LV2*" float
riverctl rule-add -app-id "REAPER" -title "*CLAP*" float
riverctl rule-add -app-id "REAPER" -title "*JS:*" float

# Diálogos y ventanas secundarias
riverctl rule-add -app-id "REAPER" -title "Preferences*" float
riverctl rule-add -app-id "REAPER" -title "Render*" float
riverctl rule-add -app-id "REAPER" -title "Actions*" float
riverctl rule-add -app-id "REAPER" -title "Project Settings*" float
riverctl rule-add -app-id "REAPER" -title "*MIDI*" float
riverctl rule-add -app-id "REAPER" -title "Media Explorer*" float
riverctl rule-add -app-id "REAPER" -title "Project Bay*" float
riverctl rule-add -app-id "REAPER" -title "Routing*" float
riverctl rule-add -app-id "REAPER" -title "Track Manager*" float

# Server-side decorations para plugins (evita conflictos de tamaño)
riverctl rule-add -app-id "REAPER" -title "*FX:*" ssd
riverctl rule-add -app-id "REAPER" -title "*VST*" ssd
riverctl rule-add -app-id "REAPER" -title "*LV2*" ssd
riverctl rule-add -app-id "REAPER" -title "*CLAP*" ssd

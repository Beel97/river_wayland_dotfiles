#!/bin/sh

# --- Reglas para REAPER (DAW) ---

# Estrategia: Todo REAPER flota por defecto para evitar que diálogos ocultos bloqueen la UI
riverctl rule-add -app-id "REAPER" float

# Forzar la ventana principal a NO flotar (tilear)
# El título empieza con "REAPER v"
riverctl rule-add -app-id "REAPER" -title "REAPER v*" no-float

# Plugins/FX y diálogos conocidos (asegurar SSD para evitar problemas de redimensionado)
# Nota: "ssd" activa decoraciones del servidor, lo que ayuda con plugins VST antiguos.
riverctl rule-add -app-id "REAPER" -title "*FX:*" ssd
riverctl rule-add -app-id "REAPER" -title "*VST*" ssd
riverctl rule-add -app-id "REAPER" -title "*LV2*" ssd
riverctl rule-add -app-id "REAPER" -title "*CLAP*" ssd
riverctl rule-add -app-id "REAPER" -title "*JS:*" ssd


# Diálogos que suelen dar problemas de foco
riverctl rule-add -app-id "REAPER" -title "Preferences*" float
riverctl rule-add -app-id "REAPER" -title "Render*" float
riverctl rule-add -app-id "REAPER" -title "Actions*" float
riverctl rule-add -app-id "REAPER" -title "Project Settings*" float
riverctl rule-add -app-id "REAPER" -title "Routing*" float
riverctl rule-add -app-id "REAPER" -title "Track Manager*" float


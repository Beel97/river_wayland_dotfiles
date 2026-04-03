#!/bin/sh

# --- Reglas de Ventanas Globales ---

# Diálogos y ventanas de sistema comunes
riverctl rule-add -app-id "float-alacritty" float
riverctl rule-add -app-id "pavucontrol" float
riverctl rule-add -app-id "nm-connection-editor" float
riverctl rule-add -app-id "zenity" float
riverctl rule-add -app-id "kakaotalk.exe" float # Ejemplo para Wine

# Navegadores y Media
riverctl rule-add -title "Picture-in-Picture" float
riverctl rule-add -title "Library" float # Firefox/Librewolf
riverctl rule-add -app-id "firefox" -title "DevTools" float

# Nota: En River, las ventanas FULLSCREEN tapan a las ventanas FLOTANTES.
# Si quieres que la ventana principal de REAPER ocupe toda la pantalla
# sin tapar los diálogos, usa el comando "zoom" (Mod + Enter) en lugar de 
# Fullscreen (Mod + Shift + F).


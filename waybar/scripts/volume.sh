#!/bin/bash

# Usar 'sget' para una salida más simple y predecible
STATE_INFO=$(amixer sget 'Master')

# Comprobar si la línea de estado contiene "[off]"
if echo "$STATE_INFO" | grep -q '\[off\]'; then
    # Si está muteado, mostrar el ícono de mute
    echo '{"text": "󰝟 Muted", "class": "muted", "tooltip": "Volume: Muted"}'
else
    # Si no está muteado, extraer el porcentaje de la primera línea que lo contenga
    VOLUME=$(echo "$STATE_INFO" | grep -o '\[[0-9]*%\]' | head -n 1 | tr -d '[]%')
    
    # Elegir el ícono según el nivel de volumen
    if [ -z "$VOLUME" ]; then
        # Fallback si no se encuentra el volumen
        echo '{"text": "Error ", "tooltip": "Could not parse volume"}'
    elif [ "$VOLUME" -le 0 ]; then
        ICON=""
    elif [ "$VOLUME" -lt 50 ]; then
        ICON=""
    else
        ICON="  "
    fi
    
    # Mostrar el ícono y el porcentaje - CORREGIDO
    echo "{\"text\": \"$ICON $VOLUME%\", \"tooltip\": \"Volume: $VOLUME%\"}"
fi

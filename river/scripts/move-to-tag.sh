#!/bin/bash

# Uso: ./script.sh [next|previous] [numero_de_tag]
DIRECTION=$1
TAG_INDEX=$2

# 1. Calculamos la máscara: 2^(TAG_INDEX - 1)
MASK=$((1 << (TAG_INDEX - 1)))

# 2. Movemos la ventana enfocada al siguiente/previo monitor
riverctl move-view-to-output "$DIRECTION"

# 3. Le asignamos el tag específico en ese nuevo monitor
riverctl set-view-tags "$MASK"

# (Opcional) Enfocar el monitor al que movimos la ventana
riverctl focus-output "$DIRECTION"

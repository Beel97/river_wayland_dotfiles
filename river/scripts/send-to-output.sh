#!/bin/sh
# Archivo: ~/.config/river/send-to-output.sh

direction=$1

# 1. Enviar la ventana al monitor destino
riverctl send-to-output $direction

# 2. Mover el foco al monitor destino
riverctl focus-output $direction

# NOTA: Como river no permite leer los tags del destino,
# la ventana conservará sus tags originales.
# Si al moverla desaparece, solo pulsa el número del tag (ej. Mod+1) en el nuevo monitor.

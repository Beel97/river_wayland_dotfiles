#!/bin/bash

# ==============================================================================
# CONFIGURATION EXPORTER V2.0 - "The HashMap Initiative"
# Overseer: GLaDOS
# ==============================================================================

set -e  # Abortar al primer signo de debilidad (error).

# Detectar directorio base del script (Ruta Absoluta)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"

log_info() { echo -e "\033[1;34m[INFO]\033[0m $1"; }
log_success() { echo -e "\033[1;32m[SUCCESS]\033[0m $1"; }
log_warn() { echo -e "\033[1;33m[WARNING]\033[0m $1"; }

# ==============================================================================
# DECLARATIVE CONFIGURATION MATRIX
# Clave: Ruta relativa en tu REPO (Fuente)
# Valor: Ruta absoluta en tu SISTEMA (Destino)
# ==============================================================================
declare -A FILES_TO_LINK

# --- Archivos Sueltos (Home) ---
FILES_TO_LINK["zsh/.zshrc"]="$HOME/.zshrc"
#FILES_TO_LINK["xorg/.xinitrc"]="$HOME/.xinitrc"
#FILES_TO_LINK["xorg/.xprofile"]="$HOME/.xprofile"

# --- Archivos Sueltos (Config) ---
# Forzamos la estructura de carpetas correcta para Alacritty
FILES_TO_LINK["alacritty"]="$CONFIG_DIR/alacritty"

# --- Directorios Completos ---
FILES_TO_LINK["nvim"]="$CONFIG_DIR/nvim"
FILES_TO_LINK["qutebrowser"]="$CONFIG_DIR/qutebrowser"
FILES_TO_LINK["superfile"]="$CONFIG_DIR/superfile"
FILES_TO_LINK["matugen"]="$CONFIG_DIR/matugen"
FILES_TO_LINK["zellij"]="$CONFIG_DIR/zellij"
FILES_TO_LINK["river"]="$CONFIG_DIR/river"
FILES_TO_LINK["waybar"]="$CONFIG_DIR/waybar"
FILES_TO_LINK["wofi"]="$CONFIG_DIR/wofi"
FILES_TO_LINK["superfile"]="$CONFIG_DIR/superfile"
FILES_TO_LINK["dunst"]="$CONFIG_DIR/dunst"
FILES_TO_LINK["satty"]="$CONFIG_DIR/satty"
FILES_TO_LINK["swaync"]="$CONFIG_DIR/swaync"






# --- Casos Especiales (Tu opencode) ---
# Asumo que dentro de tu carpeta 'opencode' hay un 'opencode.json'
#FILES_TO_LINK["opencode/opencode.json"]="$CONFIG_DIR/opencode/opencode.json"

# ==============================================================================
# EXECUTION ENGINE
# ==============================================================================

link_item() {
    local src_rel="$1"
    local target_abs="$2"
    local src_abs="$SCRIPT_DIR/$src_rel"

    # 1. Validación de Fuente
    if [ ! -e "$src_abs" ]; then
        log_warn "Source not found: $src_abs. Skipping..."
        return
    fi

    # 2. Creación de Directorio Padre (Si no existe)
    # Esto soluciona el problema de alacritty/alacritty.toml si la carpeta no existe
    local target_dir=$(dirname "$target_abs")
    if [ ! -d "$target_dir" ]; then
        log_info "Creating missing parent directory: $target_dir"
        mkdir -p "$target_dir"
    fi

    # 3. Gestión de Colisiones y Backups
    if [ -e "$target_abs" ] || [ -L "$target_abs" ]; then
        local current_link
        current_link=$(readlink -f "$target_abs" 2>/dev/null || echo "")

        if [ "$current_link" == "$src_abs" ]; then
            log_info "Link already correct: $src_abs in $target_abs"
            return
        fi

        log_warn "Backup: Moving $target_abs to ${target_abs}.bak"
        mv "$target_abs" "${target_abs}.bak"
    fi

    # 4. Enlace
    ln -sf "$src_abs" "$target_abs"
    log_success "Linked: $src_rel -> $target_abs"
}

# Iterar sobre la matriz (El orden no está garantizado en Bash, pero no importa aquí)
echo "---------------------------------------------------"
log_info "Starting synchronization..."
echo "---------------------------------------------------"

for src in "${!FILES_TO_LINK[@]}"; do
    target="${FILES_TO_LINK[$src]}"
    link_item "$src" "$target"
done

echo "---------------------------------------------------"
log_info "Process complete. Do not delete your repository."

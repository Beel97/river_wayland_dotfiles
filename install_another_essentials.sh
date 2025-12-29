#!/bin/bash

# ==============================================================================
# 1. CONFIGURACIÓN (QUÉ INSTALAR)
# ==============================================================================

# Paquetes del sistema (Nombres genéricos)
NATIVE_PACKAGES=(
    "amixer"
)

# ==============================================================================
# 2. UTILIDADES Y LOGGING
# ==============================================================================

set -e

log_info() { echo -e "\e[34m[INFO]\e[0m $1"; }
log_success() { echo -e "\e[32m[OK]\e[0m $1"; }
log_error() { echo -e "\e[31m[ERROR]\e[0m $1"; }

check_root() {
    if [ "$EUID" -ne 0 ]; then
        log_error "Por favor ejecuta este script como root (sudo)."
        exit 1
    fi
}

detect_distro() {
    if [ -f /etc/arch-release ]; then
        echo "arch"
    elif [ -f /etc/debian_version ]; then
        echo "debian"
    else
        echo "unknown"
    fi
}

# ==============================================================================
# 3. ESTRATEGIAS DE INSTALACIÓN
# ==============================================================================

update_system() {
    DISTRO=$(detect_distro)
    log_info "Actualizando repositorios para $DISTRO..."
    case $DISTRO in
        "arch") pacman -Syu --noconfirm ;;
        "debian") apt update && apt upgrade -y ;;
    esac
}

install_native() {
    PKG=$1
    DISTRO=$(detect_distro)
    REAL_PKG=""

    if [ "$DISTRO" == "debian" ]; then
        case $PKG in
            "amixer") REAL_PKG="alsa-utils" ;;
            *) REAL_PKG=$PKG ;;
        esac

        log_info "Instalando nativo (APT): $REAL_PKG"
        apt install -y $REAL_PKG

    elif [ "$DISTRO" == "arch" ]; then
        case $PKG in
            "amixer") REAL_PKG="alsa-utils" ;;
            *) REAL_PKG=$PKG ;;
        esac

        log_info "Instalando nativo (PACMAN): $REAL_PKG"
        # Sin comillas en REAL_PKG para que detecte múltiples paquetes
        pacman -S --noconfirm --needed $REAL_PKG
    fi
}

# ==============================================================================
# 4. MAIN LOOP
# ==============================================================================

main() {
    check_root
    update_system

    # 1. Nativos
    for pkg in "${NATIVE_PACKAGES[@]}"; do
        install_native "$pkg"
    done

    log_success "¡Instalación de paquetes nativos completa!"
}

main

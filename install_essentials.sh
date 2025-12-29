#!/bin/bash

# ==============================================================================
# 1. CONFIGURACIÓN (QUÉ INSTALAR)
# ==============================================================================

# Paquetes del sistema (Nombres genéricos)
NATIVE_PACKAGES=(
    "git"
    "curl"        # Necesario para instalar spf y rust
    "wget"
    "neovim"
    "zsh"
    "alacritty"
    "qutebrowser"
    "fastfetch"   # Reemplazo moderno de neofetch
    "ripgrep"
    "bat"
    "xorg"
    "python3-pip" # Se traduce automáticamente según la distro abajo
    "python-pipx"
    "hurl"
    "fzf"
    "zoxide"
    "swww"
    "waybar"
    "sddm"
    "qt5-wayland"
    "wl-clipboard"
    #"dunst"
    "swaync"
    "libnotify"
    "grim"
    "slurp"
    "satty"
    "fd"
    "chafa"
)

# Herramientas modernas via Cargo (Rust)
# Estas a veces no están en repos nativos o están desactualizadas
CARGO_CRATES=(
    "eza"     
    "sd"      
    "zellij"  
    "starship"
    "matugen"
)

# Paquetes Python
PIP_PACKAGES=(
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
            "neovim") REAL_PKG="neovim" ;; 
            "bat") REAL_PKG="bat" ;; 
            "xorg") REAL_PKG="xorg" ;;
            "fastfetch") 
                # En Ubuntu antiguo fastfetch requiere PPA, aquí asumimos versión reciente o snap
                # Si falla, podrías agregar lógica extra, pero lo dejamos simple.
                REAL_PKG="fastfetch" 
                ;;
            *) REAL_PKG=$PKG ;;
        esac
        
        log_info "Instalando nativo (APT): $REAL_PKG"
        apt install -y $REAL_PKG 

        # Hack para bat en Debian
        if [ "$PKG" == "bat" ] && [ ! -f /usr/local/bin/bat ]; then
            ln -s /usr/bin/batcat /usr/local/bin/bat 2>/dev/null || true
        fi

    elif [ "$DISTRO" == "arch" ]; then
        case $PKG in
            # Corrección: xorg-apps no existe, usamos xinit para startx
            "xorg") REAL_PKG="xorg-server xorg-xinit xorg-xrandr" ;;
            # Corrección: nombre de pip en arch
            "python3-pip") REAL_PKG="python-pip" ;; 
            *) REAL_PKG=$PKG ;;
        esac

        log_info "Instalando nativo (PACMAN): $REAL_PKG"
        # Sin comillas en REAL_PKG para que detecte múltiples paquetes
        pacman -S --noconfirm --needed $REAL_PKG
    fi
}

install_rust_env() {
    # Instalamos Rust globalmente o verificamos si existe
    if ! command -v cargo &> /dev/null; then
        log_info "Rust/Cargo no detectado. Instalando..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        # Cargamos entorno para la sesión actual
        source $HOME/.cargo/env
    else
        log_success "Rust ya está instalado."
    fi
}

install_cargo_crate() {
    CRATE=$1
    log_info "Instalando crate de Rust: $CRATE"
    
    # Truco: Usamos la ruta absoluta de cargo del usuario root o del usuario actual
    # Si sudo no encuentra cargo, intentamos buscarlo en ~/.cargo/bin
    CARGO_BIN="$HOME/.cargo/bin/cargo"
    
    if [ -f "$CARGO_BIN" ]; then
        "$CARGO_BIN" install "$CRATE" --locked || log_error "Fallo al instalar $CRATE"
    else
        # Si cargo está en el PATH global
        cargo install "$CRATE" --locked || log_error "Fallo al instalar $CRATE"
    fi
}

install_pip_pkg() {
    PKG=$1
    log_info "Instalando paquete Python: $PKG"
    # --break-system-packages es necesario en distros nuevas de Arch/Ubuntu 24.04
    pipx install "$PKG" --break-system-packages 2>/dev/null || pip install "$PKG"
}

install_superfile() {
    log_info "Instalando Superfile (spf) mediante script oficial..."
    
    # Ejecutamos el script oficial. 
    # bash -c ejecuta el string descargado.
    bash -c "$(curl -sLo- https://superfile.dev/install.sh)" || log_error "Fallo al instalar Superfile"
    
    log_success "Superfile instalado correctamente."
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

    # 2. Rust Environment
    install_rust_env

    # 3. Crates de Rust (Eza, Zellij, etc)
    for crate in "${CARGO_CRATES[@]}"; do
        install_cargo_crate "$crate"
    done
    
    # 4. Python (Pywal)
    for pip_pkg in "${PIP_PACKAGES[@]}"; do
        install_pip_pkg "$pip_pkg"
    done

    # 5. Superfile (SPF) - Instalación Custom
    install_superfile

    # 6. Oh My Zsh (Opcional, cuidado al correr como root)
    # Si quieres que se instale para tu usuario normal (no root), usa esto:
    if [ -n "$SUDO_USER" ]; then
        log_info "Configurando Oh My Zsh para usuario: $SUDO_USER"
        sudo -u "$SUDO_USER" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || true
    fi

    log_success "¡Instalación completa! Reinicia tu terminal."
}

main

#!/bin/bash

# ==============================================================================
# 🚀 MIGRATE.SH — Script de Migración Completa para Nuevo Laptop
# ==============================================================================
#
# ¿Qué hace?
#   1. Instala paquetes base (pacman, yay/paru, cargo, custom)
#   2. Configura shell (zsh, oh-my-zsh, plugins, starship)
#   3. Clona dotfiles y common_scripts
#   4. Enlaza todas las configuraciones
#   5. Configura herramientas adicionales (fnm, bun, ollama, etc)
#   6. Genera snapshot del estado actual (para respaldos futuros)
#
# Uso:
#   curl -sL <url-raw-de-este-script> | bash
#   # o si ya tienes el repo clonado:
#   cd ~/.dotfiles && ./migrate.sh
#
# Flags:
#   --skip-packages    Omitir instalación de paquetes
#   --skip-links       Omitir creación de symlinks
#   --skip-shell       Omitir configuración de shell
#   --dry-run          Solo mostrar qué haría sin ejecutar nada
#   --snapshot-only    Solo generar un snapshot del sistema actual
#
# ==============================================================================

set -euo pipefail

# ─── Colores ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# ─── Variables Globales ──────────────────────────────────────────────────────
DOTFILES_DIR="$HOME/.dotfiles"
DOTFILES_REPO="https://github.com/beel/.dotfiles.git"  # ← CAMBIAR por tu repo real
COMMON_SCRIPTS_REPO="https://github.com/beel/common_scripts.git"  # ← CAMBIAR por tu repo real
CONFIG_DIR="$HOME/.config"
SNAPSHOT_DIR="$DOTFILES_DIR/.snapshots"
LOG_FILE="/tmp/migrate_$(date +%Y%m%d_%H%M%S).log"

SKIP_PACKAGES=false
SKIP_LINKS=false
SKIP_SHELL=false
DRY_RUN=false
SNAPSHOT_ONLY=false

# ─── Parse Args ──────────────────────────────────────────────────────────────
for arg in "$@"; do
    case $arg in
        --skip-packages) SKIP_PACKAGES=true ;;
        --skip-links)    SKIP_LINKS=true ;;
        --skip-shell)    SKIP_SHELL=true ;;
        --dry-run)       DRY_RUN=true ;;
        --snapshot-only) SNAPSHOT_ONLY=true ;;
        --help|-h)
            echo "Uso: ./migrate.sh [--skip-packages] [--skip-links] [--skip-shell] [--dry-run] [--snapshot-only]"
            exit 0
            ;;
    esac
done

# ─── Logging ─────────────────────────────────────────────────────────────────
log_info()    { echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$LOG_FILE"; }
log_success() { echo -e "${GREEN}[  OK]${NC} $1" | tee -a "$LOG_FILE"; }
log_warn()    { echo -e "${YELLOW}[WARN]${NC} $1" | tee -a "$LOG_FILE"; }
log_error()   { echo -e "${RED}[FAIL]${NC} $1" | tee -a "$LOG_FILE"; }
log_step()    { echo -e "\n${MAGENTA}${BOLD}━━━ $1 ━━━${NC}\n" | tee -a "$LOG_FILE"; }
log_header()  { echo -e "\n${CYAN}${BOLD}══════════════════════════════════════════${NC}" | tee -a "$LOG_FILE"
                echo -e "${CYAN}${BOLD}  $1${NC}" | tee -a "$LOG_FILE"
                echo -e "${CYAN}${BOLD}══════════════════════════════════════════${NC}\n" | tee -a "$LOG_FILE"; }

run_cmd() {
    if [ "$DRY_RUN" = true ]; then
        log_info "[DRY-RUN] $*"
    else
        "$@" 2>&1 | tee -a "$LOG_FILE"
    fi
}

# ─── Verificaciones ──────────────────────────────────────────────────────────
check_arch() {
    if [ ! -f /etc/arch-release ]; then
        log_error "Este script está diseñado para Arch Linux."
        log_warn  "Puedes usar --skip-packages para omitir la instalación y solo enlazar configs."
        if [ "$SKIP_PACKAGES" = false ]; then
            exit 1
        fi
    fi
}

check_internet() {
    if ! ping -c 1 -W 3 archlinux.org &>/dev/null; then
        log_error "Sin conexión a internet. Verifica tu red."
        exit 1
    fi
    log_success "Conexión a internet verificada."
}

check_sudo() {
    if ! sudo -v; then
        log_error "Se necesitan privilegios de sudo."
        exit 1
    fi
    # Mantener sudo activo durante el script
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
}

# ==============================================================================
# 📸 SNAPSHOT — Genera un estado del sistema para migración futura
# ==============================================================================
generate_snapshot() {
    log_header "📸 Generando Snapshot del Sistema"

    mkdir -p "$SNAPSHOT_DIR"
    local SNAP_FILE="$SNAPSHOT_DIR/snapshot_$(date +%Y%m%d_%H%M%S).md"

    {
        echo "# 📸 System Snapshot — $(date '+%Y-%m-%d %H:%M:%S')"
        echo ""
        echo "## Sistema"
        echo '```'
        cat /etc/os-release 2>/dev/null || echo "No /etc/os-release"
        echo ""
        echo "Kernel: $(uname -r)"
        echo "Hostname: $(hostname)"
        echo "User: $(whoami)"
        echo '```'
        echo ""

        echo "## Paquetes Instalados (pacman)"
        echo '```'
        pacman -Qqe 2>/dev/null || echo "pacman no disponible"
        echo '```'
        echo ""

        echo "## Paquetes AUR (yay/paru)"
        echo '```'
        pacman -Qqm 2>/dev/null || echo "Ninguno o no disponible"
        echo '```'
        echo ""

        echo "## Cargo Crates Instalados"
        echo '```'
        cargo install --list 2>/dev/null | grep -E '^\w' || echo "Cargo no instalado"
        echo '```'
        echo ""

        echo "## Pip/Pipx Packages"
        echo '```'
        pipx list 2>/dev/null || echo "pipx no instalado"
        echo '```'
        echo ""

        echo "## Node Versions (fnm)"
        echo '```'
        fnm list 2>/dev/null || echo "fnm no instalado"
        echo '```'
        echo ""

        echo "## Servicios Habilitados (systemd)"
        echo '```'
        systemctl list-unit-files --state=enabled --user 2>/dev/null || true
        echo "---"
        sudo systemctl list-unit-files --state=enabled 2>/dev/null | grep -v "^$" | head -50 || true
        echo '```'
        echo ""

        echo "## Fuentes Instaladas"
        echo '```'
        fc-list : family | sort -u | grep -i "nerd\|fira\|roboto\|inter" 2>/dev/null || echo "fc-list no disponible"
        echo '```'
        echo ""

        echo "## Symlinks Activos (~/.config)"
        echo '```'
        find "$HOME/.config" -maxdepth 1 -type l -exec ls -la {} \; 2>/dev/null || true
        echo '```'
        echo ""

        echo "## Ollama Models"
        echo '```'
        ollama list 2>/dev/null || echo "Ollama no instalado"
        echo '```'
        echo ""

        echo "## SSH Keys"
        echo '```'
        ls -la "$HOME/.ssh/"*.pub 2>/dev/null || echo "Sin SSH keys públicas"
        echo '```'

    } > "$SNAP_FILE"

    log_success "Snapshot guardado en: $SNAP_FILE"

    # También generar listas planas para instalación rápida
    pacman -Qqe 2>/dev/null > "$SNAPSHOT_DIR/pacman_packages.txt" || true
    pacman -Qqm 2>/dev/null > "$SNAPSHOT_DIR/aur_packages.txt" || true
    cargo install --list 2>/dev/null | grep -E '^\w' | awk '{print $1}' > "$SNAPSHOT_DIR/cargo_crates.txt" || true

    log_success "Listas de paquetes generadas en $SNAPSHOT_DIR/"
}

# ==============================================================================
# 📦 INSTALACIÓN DE PAQUETES
# ==============================================================================

install_aur_helper() {
    log_step "Instalando AUR Helper (yay)"

    if command -v yay &>/dev/null; then
        log_success "yay ya está instalado."
        return
    fi

    if command -v paru &>/dev/null; then
        log_success "paru ya está instalado (usando como alternativa)."
        return
    fi

    log_info "Instalando yay desde AUR..."
    run_cmd sudo pacman -S --needed --noconfirm base-devel git
    local tmpdir
    tmpdir=$(mktemp -d)
    run_cmd git clone https://aur.archlinux.org/yay-bin.git "$tmpdir/yay-bin"
    (cd "$tmpdir/yay-bin" && run_cmd makepkg -si --noconfirm)
    rm -rf "$tmpdir"
    log_success "yay instalado correctamente."
}

install_native_packages() {
    log_step "Instalando Paquetes Nativos (pacman)"

    local PACKAGES=(
        # ── Core ──
        git curl wget base-devel

        # ── Shell & Terminal ──
        zsh alacritty

        # ── Editor ──
        neovim

        # ── Wayland & WM ──
        river rivertile wayland qt5-wayland
        swww kanshi
        sddm

        # ── Barra, Launcher, Notificaciones ──
        waybar wofi swaync libnotify

        # ── Screenshots & Clipboard ──
        wl-clipboard grim slurp satty

        # ── CLI Tools ──
        fastfetch ripgrep bat fzf zoxide fd chafa
        hurl brightnessctl

        # ── Audio ──
        alsa-utils pipewire pipewire-pulse wireplumber

        # ── System Monitors ──
        btop

        # ── Python ──
        python-pip python-pipx

        # ── Fonts ──
        ttf-firacode-nerd ttf-roboto

        # ── Development ──
        docker docker-compose

        # ── Xorg (legacy compat) ──
        xorg-server xorg-xinit xorg-xrandr
    )

    log_info "Actualizando sistema..."
    run_cmd sudo pacman -Syu --noconfirm

    log_info "Instalando ${#PACKAGES[@]} paquetes..."
    run_cmd sudo pacman -S --needed --noconfirm "${PACKAGES[@]}"

    log_success "Paquetes nativos instalados."
}

install_aur_packages() {
    log_step "Instalando Paquetes AUR"

    local AUR_HELPER="yay"
    command -v paru &>/dev/null && AUR_HELPER="paru"

    local AUR_PACKAGES=(
        qutebrowser
        # Agrega más paquetes AUR aquí si los necesitas
    )

    for pkg in "${AUR_PACKAGES[@]}"; do
        if pacman -Qi "$pkg" &>/dev/null; then
            log_info "$pkg ya está instalado."
        else
            log_info "Instalando AUR: $pkg"
            run_cmd "$AUR_HELPER" -S --noconfirm "$pkg"
        fi
    done

    log_success "Paquetes AUR instalados."
}

install_rust_and_crates() {
    log_step "Configurando Rust & Cargo Crates"

    if ! command -v cargo &>/dev/null; then
        log_info "Instalando Rust via rustup..."
        run_cmd curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
    else
        log_success "Rust ya está instalado."
    fi

    local CRATES=(eza sd zellij starship matugen)

    for crate in "${CRATES[@]}"; do
        if command -v "$crate" &>/dev/null; then
            log_info "$crate ya está instalado."
        else
            log_info "Instalando cargo crate: $crate"
            run_cmd cargo install "$crate" --locked || log_warn "Fallo al instalar $crate"
        fi
    done

    log_success "Cargo crates instalados."
}

install_custom_tools() {
    log_step "Instalando Herramientas Custom"

    # ── Superfile (spf) ──
    if ! command -v spf &>/dev/null; then
        log_info "Instalando Superfile..."
        run_cmd bash -c "$(curl -sLo- https://superfile.dev/install.sh)"
    else
        log_success "Superfile ya está instalado."
    fi

    # ── Bun ──
    if ! command -v bun &>/dev/null; then
        log_info "Instalando Bun..."
        run_cmd curl -fsSL https://bun.sh/install | bash
    else
        log_success "Bun ya está instalado."
    fi

    # ── fnm (Node Version Manager) ──
    if ! command -v fnm &>/dev/null; then
        log_info "Instalando fnm..."
        run_cmd curl -fsSL https://fnm.vercel.app/install | bash
    else
        log_success "fnm ya está instalado."
    fi

    # ── Ollama ──
    if ! command -v ollama &>/dev/null; then
        log_info "Instalando Ollama..."
        run_cmd curl -fsSL https://ollama.ai/install.sh | sh
    else
        log_success "Ollama ya está instalado."
    fi

    log_success "Herramientas custom instaladas."
}

# ==============================================================================
# 🐚 CONFIGURACIÓN DE SHELL
# ==============================================================================

setup_shell() {
    log_step "Configurando Shell (zsh + oh-my-zsh)"

    # ── Oh My Zsh ──
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log_info "Instalando Oh My Zsh..."
        run_cmd sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        log_success "Oh My Zsh ya está instalado."
    fi

    # ── Plugins de Zsh ──
    local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
        log_info "Instalando zsh-syntax-highlighting..."
        run_cmd git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
            "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    fi

    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        log_info "Instalando zsh-autosuggestions..."
        run_cmd git clone https://github.com/zsh-users/zsh-autosuggestions.git \
            "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    fi

    # ── Cambiar shell a zsh ──
    if [ "$SHELL" != "$(which zsh)" ]; then
        log_info "Cambiando shell a zsh..."
        run_cmd chsh -s "$(which zsh)"
        log_warn "Necesitarás cerrar sesión y volver a entrar para que el cambio de shell tenga efecto."
    else
        log_success "Shell ya es zsh."
    fi

    log_success "Shell configurada."
}

# ==============================================================================
# 🔗 CLONACIÓN Y ENLAZADO
# ==============================================================================

clone_repos() {
    log_step "Clonando Repositorios"

    # ── Dotfiles ──
    if [ -d "$DOTFILES_DIR/.git" ]; then
        log_info "Dotfiles ya clonados. Actualizando..."
        run_cmd git -C "$DOTFILES_DIR" pull --rebase
    else
        log_info "Clonando dotfiles..."
        run_cmd git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
    fi

    # ── Common Scripts ──
    if [ -d "$HOME/common_scripts/.git" ]; then
        log_info "common_scripts ya clonado. Actualizando..."
        run_cmd git -C "$HOME/common_scripts" pull --rebase
    else
        log_info "Clonando common_scripts..."
        run_cmd git clone "$COMMON_SCRIPTS_REPO" "$HOME/common_scripts"
    fi

    log_success "Repositorios listos."
}

link_all_configs() {
    log_step "Enlazando Configuraciones"

    # ─── Mapa de enlaces ─────────────────────────────────────────────────────
    # Formato: "fuente_relativa|destino_absoluto"
    local LINKS=(
        "zsh/.zshrc|$HOME/.zshrc"
        "alacritty|$CONFIG_DIR/alacritty"
        "nvim|$CONFIG_DIR/nvim"
        "qutebrowser|$CONFIG_DIR/qutebrowser"
        "superfile|$CONFIG_DIR/superfile"
        "matugen|$CONFIG_DIR/matugen"
        "zellij|$CONFIG_DIR/zellij"
        "river|$CONFIG_DIR/river"
        "waybar|$CONFIG_DIR/waybar"
        "wofi|$CONFIG_DIR/wofi"
        "satty|$CONFIG_DIR/satty"
        "swaync|$CONFIG_DIR/swaync"
        "kanshi|$CONFIG_DIR/kanshi"
        "opencode|$CONFIG_DIR/opencode"
    )

    for entry in "${LINKS[@]}"; do
        local src_rel="${entry%%|*}"
        local target="${entry##*|}"
        local src_abs="$DOTFILES_DIR/$src_rel"

        # Verificar que la fuente existe
        if [ ! -e "$src_abs" ]; then
            log_warn "Fuente no encontrada: $src_abs — Omitiendo."
            continue
        fi

        # Crear directorio padre si no existe
        local target_parent
        target_parent=$(dirname "$target")
        mkdir -p "$target_parent"

        # Verificar si ya está bien enlazado
        if [ -L "$target" ]; then
            local current
            current=$(readlink -f "$target" 2>/dev/null || echo "")
            if [ "$current" = "$src_abs" ]; then
                log_info "Ya enlazado: $src_rel → $target"
                continue
            fi
        fi

        # Backup si existe
        if [ -e "$target" ] || [ -L "$target" ]; then
            log_warn "Backup: $target → ${target}.bak"
            if [ "$DRY_RUN" = false ]; then
                mv "$target" "${target}.bak"
            fi
        fi

        # Crear symlink
        if [ "$DRY_RUN" = false ]; then
            ln -sf "$src_abs" "$target"
        fi
        log_success "Enlazado: $src_rel → $target"
    done

    log_success "Todas las configuraciones enlazadas."
}

# ==============================================================================
# ⚙️  POST-INSTALL
# ==============================================================================

post_install() {
    log_step "Post-Instalación"

    # ── Hacer ejecutables los scripts de river ──
    chmod +x "$DOTFILES_DIR/river/init" 2>/dev/null || true
    find "$DOTFILES_DIR/river/conf.d/" -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
    find "$DOTFILES_DIR/river/scripts/" -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
    log_success "Scripts de river marcados como ejecutables."

    # ── Hacer ejecutables los scripts comunes ──
    find "$HOME/common_scripts/" -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
    log_success "Scripts comunes marcados como ejecutables."

    # ── Habilitar servicios ──
    if [ "$DRY_RUN" = false ]; then
        sudo systemctl enable sddm 2>/dev/null || log_warn "No se pudo habilitar SDDM"
        sudo systemctl enable docker 2>/dev/null || log_warn "No se pudo habilitar Docker"
        sudo usermod -aG docker "$USER" 2>/dev/null || true
        log_success "Servicios habilitados."
    fi

    # ── Crear directorio de starship config ──
    mkdir -p "$CONFIG_DIR/starship" 2>/dev/null || true

    # ── Crear .zshrc.local vacío si no existe ──
    if [ ! -f "$HOME/.zshrc.local" ]; then
        cat > "$HOME/.zshrc.local" << 'EOF'
# Configuraciones locales de esta máquina
# Este archivo no se rastrea en git

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# fnm
FNM_PATH="$HOME/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "`fnm env`"
fi
EOF
        log_success "Archivo .zshrc.local creado."
    fi

    log_success "Post-instalación completada."
}

# ==============================================================================
# 🏁 MAIN
# ==============================================================================

main() {
    log_header "🚀 Migración de Dotfiles — Arch Linux"
    log_info "Log guardado en: $LOG_FILE"
    log_info "Fecha: $(date '+%Y-%m-%d %H:%M:%S')"
    echo ""

    # ── Solo snapshot? ──
    if [ "$SNAPSHOT_ONLY" = true ]; then
        generate_snapshot
        exit 0
    fi

    # ── Verificaciones ──
    check_arch
    check_internet
    check_sudo

    # ── Snapshot del estado actual (en el laptop viejo) ──
    if [ -d "$DOTFILES_DIR/.git" ]; then
        generate_snapshot
    fi

    # ── Paquetes ──
    if [ "$SKIP_PACKAGES" = false ]; then
        install_aur_helper
        install_native_packages
        install_aur_packages
        install_rust_and_crates
        install_custom_tools
    else
        log_warn "Instalación de paquetes omitida (--skip-packages)."
    fi

    # ── Shell ──
    if [ "$SKIP_SHELL" = false ]; then
        setup_shell
    else
        log_warn "Configuración de shell omitida (--skip-shell)."
    fi

    # ── Repos y Links ──
    if [ "$SKIP_LINKS" = false ]; then
        clone_repos
        link_all_configs
    else
        log_warn "Enlazado de configs omitido (--skip-links)."
    fi

    # ── Post-install ──
    post_install

    # ── Resumen Final ──
    log_header "✅ Migración Completada"
    echo -e "${GREEN}${BOLD}"
    echo "  Todo listo. Próximos pasos:"
    echo ""
    echo "  1. Cierra sesión y vuelve a entrar (para activar zsh)"
    echo "  2. Configura tu SSH key:"
    echo "     ssh-keygen -t ed25519 -C \"crazybeel97@gmail.com\""
    echo "     Agrégala a GitHub: https://github.com/settings/keys"
    echo ""
    echo "  3. Configura git:"
    echo "     git config --global user.name \"beel\""
    echo "     git config --global user.email \"crazybeel97@gmail.com\""
    echo ""
    echo "  4. Aplica un wallpaper con matugen:"
    echo "     matugen image <ruta_imagen>"
    echo ""
    echo "  5. Descarga modelos de Ollama:"
    echo "     ollama pull ministral"
    echo ""
    echo "  6. Instala una versión de Node:"
    echo "     fnm install --lts"
    echo ""
    echo "  📝 Log completo: $LOG_FILE"
    echo -e "${NC}"
}

main "$@"

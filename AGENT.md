# 🤖 AGENT.md — Perfil de Entorno de Desarrollo

> Este archivo describe el entorno de desarrollo, herramientas, convenciones y
> arquitectura de la configuración del sistema. Está diseñado para que cualquier
> agente de IA (o colaborador) pueda entender rápidamente el contexto y operar
> sobre este repositorio de dotfiles de forma efectiva.

---

## 🖥️ Sistema Operativo

| Propiedad     | Valor                  |
| ------------- | ---------------------- |
| **Distro**    | Arch Linux             |
| **Protocolo** | Wayland                |
| **WM**        | river (tiling)         |
| **DM**        | SDDM                  |
| **Shell**     | zsh (+ oh-my-zsh)      |
| **Terminal**  | Alacritty              |
| **Editor**    | Neovim (LazyVim)       |
| **Navegador** | Qutebrowser            |
| **Usuario**   | beel                   |
| **Email**     | crazybeel97@gmail.com  |

---

## 📂 Estructura del Repositorio

```
~/.dotfiles/
├── alacritty/              # Terminal GPU-accelerated
│   ├── alacritty.toml      # Config principal (importa colores matugen)
│   └── matugen_colors_alacritty.toml  # Colores generados por matugen
├── kanshi/
│   └── config              # Perfiles multi-monitor (docked/undocked)
├── matugen/
│   ├── config.toml         # Engine de colores dinámicos (Material You)
│   └── templates/          # Templates para todos los programas
│       ├── alacritty.toml
│       ├── qutebrowser-colors.py
│       ├── river-colors
│       ├── starship.toml
│       ├── superfile.toml
│       ├── waybar.css
│       ├── wofi.css
│       ├── zellij-compact.kdl
│       └── zellij-theme.kdl
├── nvim/                   # Configuración LazyVim
│   ├── init.lua            # Bootstrap (require config.lazy)
│   ├── lazyvim.json        # Extras habilitados
│   ├── lua/
│   │   ├── config/
│   │   │   ├── autocmds.lua
│   │   │   ├── keymaps.lua
│   │   │   ├── lazy.lua
│   │   │   └── options.lua
│   │   └── plugins/
│   │       ├── blade-formater.lua
│   │       ├── colorscheme.lua
│   │       ├── copilot.lua
│   │       ├── dashboard.lua
│   │       ├── dotenv.lua
│   │       ├── hurl.lua
│   │       ├── lazydocker.lua
│   │       ├── nvim-dap.lua
│   │       ├── obsidian.lua
│   │       ├── spellwarm.lua
│   │       ├── themery.lua
│   │       ├── tiny-inline-diagnostic.lua
│   │       ├── treesitter.lua
│   │       └── ui.lua
│   └── stylua.toml
├── opencode/
│   └── opencode.json       # AI coding tool (Ollama local)
├── qutebrowser/
│   ├── config.py           # Config principal
│   ├── private.py          # Datos privados (gitignored)
│   └── matugen_colors_qutebrowser.py
├── river/
│   ├── init                # Entrypoint: carga conf.d/*.sh en orden
│   ├── matugen_colors_river.sh
│   ├── conf.d/
│   │   ├── 00-variables.sh       # Variables globales (mod=Mod4, term=alacritty)
│   │   ├── 01-autostart.sh       # Daemons: kanshi, swww, rivertile, waybar, swaync
│   │   ├── 02-mouse.sh           # Configuración de mouse/trackpad
│   │   ├── 03-keybindings-wm.sh  # Básicos: Mod+T=terminal, Mod+Q=close, etc
│   │   ├── 04-keybindings-layout.sh  # rivertile layout management
│   │   ├── 05-keybindings-tags.sh    # Tags 1-9 (escritorios virtuales)
│   │   ├── 06-keybindings-multimonitor.sh  # Foco/envío entre monitores
│   │   ├── 07-keybindings-hardware.sh      # Audio (amixer), brillo
│   │   ├── 08-keybindings-extra.sh   # Screenshots, waybar toggle, wallpaper
│   │   ├── 09-rules.sh              # Window rules
│   │   ├── 10-personal-scripts.sh    # Launchers via ~/common_scripts/
│   │   └── 11-rules-reaper.sh       # Rules para REAPER (audio production)
│   └── scripts/
│       ├── move-to-tag.sh
│       └── send-to-output.sh
├── satty/
│   └── config.toml         # Screenshot annotation tool
├── superfile/
│   ├── config.toml         # TUI file manager
│   ├── hotkeys.toml
│   └── theme/
├── swaync/
│   ├── config.json         # Notification center
│   ├── style.css
│   ├── icons/
│   └── themes/
├── waybar/
│   ├── config              # Barra de estado (top)
│   ├── modules.jsonc       # Definición de módulos
│   ├── style.css
│   ├── matugen_colors_waybar.css
│   └── scripts/
├── wofi/
│   ├── config              # App launcher (horizontal, top, overlay)
│   └── style.css           # Generado por matugen
├── zellij/
│   ├── config.kdl          # Terminal multiplexer
│   ├── layouts/
│   ├── plugins/
│   └── themes/
├── zsh/
│   └── .zshrc              # Config principal de zsh
├── install_essentials.sh       # Script de instalación de paquetes
├── install_another_essentials.sh  # Paquetes adicionales
├── export_config.sh            # Symlink interactivo
├── export_all_configs.sh       # Symlink automático completo
├── .gitignore
└── README.md
```

### Archivos Externos Relacionados

| Archivo                   | Propósito                             |
| ------------------------- | ------------------------------------- |
| `~/.zshrc`                | Symlink → `~/.dotfiles/zsh/.zshrc`   |
| `~/.zshrc.local`          | Config local privada (gitignored)     |
| `~/.gitconfig`            | Configuración global de git           |
| `~/common_scripts/`       | Repo separado con launchers y scripts |

---

## 🎨 Sistema de Colores: Matugen (Material You)

El sistema usa **matugen** para generar colores dinámicos basados en el wallpaper actual. Matugen actúa como el motor central de theming:

### Flujo de Colores
```
Wallpaper → matugen → templates/ → archivos de color por programa
                                  ├── alacritty  (matugen_colors_alacritty.toml)
                                  ├── waybar     (matugen_colors_waybar.css)
                                  ├── wofi       (style.css)
                                  ├── qutebrowser (matugen_colors_qutebrowser.py)
                                  ├── river      (matugen_colors_river.sh)
                                  ├── superfile  (matugen_colors_superfile.toml)
                                  ├── starship   (starship.toml)
                                  ├── zellij     (theme + layout .kdl)
                                  └── swww       (aplica wallpaper)
```

### Convención de Nombres
- Templates: `matugen/templates/<programa>.<ext>`
- Outputs: `<programa>/matugen_colors_<programa>.<ext>`
- Post-hooks: Recarga automática del programa después de generar colores.

---

## ⌨️ Keybindings Principales (river)

| Acción                    | Atajo                     |
| ------------------------- | ------------------------- |
| Abrir terminal            | `Mod4 + T`                |
| Cerrar ventana            | `Mod4 + Q`                |
| Salir de river            | `Mod4 + Shift + C`        |
| Focus siguiente/previo    | `Mod4 + J / K`            |
| Swap siguiente/previo     | `Mod4 + Shift + J / K`    |
| Zoom (promote main)       | `Mod4 + Enter`            |
| Fullscreen                | `Mod4 + Shift + F`        |
| Toggle float              | `Mod4 + Shift + Space`    |
| Screenshot (área)         | `Mod4 + P`                |
| Screenshot (completo)     | `Mod4 + Shift + P`        |
| App launcher (wofi)       | `Mod4 + A`                |
| Browser launcher          | `Mod4 + B`                |
| WiFi connect              | `Mod4 + W`                |
| Wallpaper setter          | `Mod4 + Shift + W`        |
| Notificaciones            | `Mod4 + N`                |
| Toggle waybar             | `Ctrl + Alt + W`          |
| Logout/Power              | `Mod4 + Backspace`        |
| Tags 1-9                  | `Mod4 + [1-9]`            |
| Mover a tag               | `Mod4 + Shift + [1-9]`    |
| Monitor izq/der           | `Mod4 + [ / ]`            |
| Enviar a monitor          | `Mod4 + Shift + [ / ]`    |
| Previous tags             | `Mod4 + Tab`              |
| Layout ratio ±            | `Mod4 + H / L`            |
| Resize                    | `Mod4 + Shift + H / L`    |
| Vol up/down/mute          | Teclas multimedia          |
| Brillo up/down            | Teclas multimedia          |

---

## 📦 Stack de Paquetes

### Paquetes Nativos (pacman)
```
git, curl, wget, neovim, zsh, alacritty, qutebrowser, fastfetch, ripgrep,
bat, xorg-server, xorg-xinit, xorg-xrandr, python-pip, python-pipx, hurl,
fzf, zoxide, swww, waybar, sddm, qt5-wayland, wl-clipboard, swaync,
libnotify, grim, slurp, satty, fd, chafa, alsa-utils, btop
```

### Cargo Crates (Rust)
```
eza, sd, zellij, starship, matugen
```

### Herramientas Adicionales
```
superfile (spf), oh-my-zsh, fnm (Node version manager), bun
```

### Plugins de Zsh
```
git, zsh-syntax-highlighting, zsh-autosuggestions, fzf
```

### Neovim (LazyVim Extras)
```
coding:     mini-surround, yanky
editor:     harpoon2, illuminate, inc-rename
lang:       docker, go, json, markdown, python, rust, sql, tailwind, toml, vue, yaml
ui:         mini-animate
util:       dot, mini-hipatterns, rest (hurl)
plugins:    copilot, dashboard, hurl, lazydocker, nvim-dap, obsidian, themery, treesitter
```

---

## 🖥️ Multi-Monitor

Configurado via **kanshi** con dos perfiles:

| Perfil       | Configuración                                               |
| ------------ | ----------------------------------------------------------- |
| **docked**   | HDMI-A-2 (izq), HDMI-A-1 (centro), eDP-1 (der, laptop)   |
| **undocked** | Solo eDP-1                                                  |

Resolución: 1920x1080 en todos los monitores.

---

## 🔧 Convenciones y Patrones

### Archivos Privados
- Patrón: `*.local` y archivos específicos como `qutebrowser/private.py`
- Todos listados en `.gitignore`
- Se cargan condicionalmente (`if [ -f ... ]; then source ...; fi`)

### Scripts
- **Scripts del WM:** `~/.dotfiles/river/conf.d/` (numerados para orden)
- **Scripts de usuario:** `~/common_scripts/` (repo separado)
  - `launchers/` — App launcher, browser launcher, logout options
  - `system/` — WiFi connect y utilidades del sistema

### Instalación: Estrategia Multi-Distro
Los scripts de instalación soportan Arch y Debian, con traducción de nombres de paquetes:
```
"python3-pip" → "python-pip" (arch)
"xorg"        → "xorg-server xorg-xinit xorg-xrandr" (arch)
"amixer"      → "alsa-utils" (ambas)
```

### Enlazado de Configuraciones
Se usa **symlinks** desde `~/.dotfiles/` hacia `~/.config/` y `~/`:
- `export_config.sh` — Interactivo (pregunta por cada config)
- `export_all_configs.sh` — Automático (todas las configs)
- Backup automático: si el destino existe, se mueve a `*.bak`

---

## 🎵 Producción Musical

Se usa **REAPER** para producción de audio con rules específicas en river:
- Archivo de rules: `conf.d/11-rules-reaper.sh`
- Plugins VST en `~/.vst/`, `~/.vst3/`, `~/.lv2/`
- DrumGizmo instalado

---

## 🤖 AI / LLM Local

| Herramienta  | Propósito                          |
| ------------ | ---------------------------------- |
| **Ollama**   | LLM local (ministral-oc, etc)     |
| **OpenCode** | AI coding tool (apunta a Ollama)  |

OpenCode config: `~/.dotfiles/opencode/opencode.json`
- Provider: Ollama local en `http://localhost:11434/v1`
- Tools habilitados: shell, write, edit

---

## 🐳 Contenedores

- Docker instalado (aliases: `dcu`, `dcd`)
- LazyDocker integrado en Neovim
- VirtualBox presente

---

## 📝 Idioma y Spelling

- Idioma principal del código/comentarios: **Español** (con mezcla de inglés en código)
- Neovim spelling: `en_us`, `es_mx`
- El README y documentación están en español

---

## 🔑 Rutas Importantes del PATH

```bash
$HOME/.local/bin          # Binarios locales
$HOME/.cargo/bin          # Rust/Cargo
$HOME/.bun/bin            # Bun (JS runtime)
$HOME/.local/share/fnm    # Node version manager
$HOME/.opencode/bin       # OpenCode AI
```

---

## 📋 Fuente del Sistema

- **FiraCode Nerd Font Mono** — Para terminal e iconos
- Estilos: SemiBold (normal), Bold, Italic

---

## ⚡ Cómo Trabajar con este Repo

1. **Clonar:** `git clone <repo> ~/.dotfiles`
2. **Instalar paquetes:** `sudo ./install_essentials.sh`
3. **Enlazar configs:** `./export_all_configs.sh` (o `export_config.sh` para interactivo)
4. **Cambiar wallpaper/colores:** `matugen image <ruta_imagen>` (regenera todos los colores)
5. **Añadir nueva config:** Agregar al mapa `FILES_TO_LINK` en ambos scripts de export
6. **Datos privados:** Crear `*.local` o archivos específicos, se cargan automáticamente

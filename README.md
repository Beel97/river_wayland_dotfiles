# Mis Dotfiles para Arch Linux + river

¡Bienvenido a mi colección personal de archivos de configuración! Estos dotfiles están diseñados para mi entorno de desarrollo, que utiliza **Arch Linux** con el compositor de ventanas **river** (Wayland).

Son un **trabajo en progreso** constante, pero creo que son un excelente punto de partida si buscas construir un entorno similar.

## 🚀 Cómo Empezar

El repositorio incluye varios scripts para ayudarte a configurar todo rápidamente.

### 1. Instalación de Paquetes

Hay dos scripts principales para la instalación:

*   `install_essentials.sh`: Instala los paquetes principales que uso a diario, como `neovim`, `zsh`, `alacritty`, `qutebrowser` y varias herramientas de línea de comandos. Está diseñado para funcionar tanto en Arch Linux como en distribuciones basadas en Debian.
*   `install_another_essentials.sh`: Instala algunos paquetes adicionales que no son estrictamente necesarios, pero que forman parte de mi configuración.

Para ejecutarlos, simplemente usa `sudo`:

```bash
sudo ./install_essentials.sh
sudo ./install_another_essentials.sh
```

### 2. Enlazado de Configuraciones

Una vez instalados los paquetes, necesitas enlazar los archivos de configuración a sus ubicaciones correctas en tu directorio de inicio. Hay dos scripts para esto:

*   `export_config.sh`: Es un script **interactivo** que te preguntará qué configuración deseas enlazar. Es la forma recomendada si quieres elegir solo algunas.
*   `export_all_configs.sh`: Este script enlazará **todas** las configuraciones automáticamente sin preguntar. Úsalo si quieres replicar mi configuración por completo.

Para ejecutar el script interactivo:

```bash
./export_config.sh
```

## 🎨 Componentes Clave

*   **Gestor de Ventanas:** `river` (un compositor Wayland de tipo _tiling_)
*   **Terminal:** `alacritty`
*   **Editor:** `neovim` (con una configuración personalizada basada en LazyVim)
*   **Shell:** `zsh` con `oh-my-zsh` y `starship`
*   **Navegador:** `qutebrowser`
*   **Lanzador de Aplicaciones:** `wofi`
*   **Barra de Estado:** `waybar`

¡Y muchas otras herramientas!

## 🔧 Personalización

Notarás que algunas configuraciones hacen referencia a archivos que no están en el repositorio (por ejemplo, `qutebrowser/private.py`, `.zshrc.local`). ¡Esto es intencional! Esos archivos están en mi `.gitignore` y contienen información personal o sensible.

Esta es una buena práctica para separar tus configuraciones públicas de las privadas. Puedes crear estos archivos tú mismo para añadir tus propias configuraciones personales sin que se rastreen en git.

## 🔄 Migración Rápida a Nuevo Laptop

Si vas a cambiar de laptop, hay un script todo-en-uno que se encarga de todo:

```bash
# En el laptop VIEJO — genera un snapshot del estado actual:
./migrate.sh --snapshot-only

# En el laptop NUEVO — migración completa:
git clone <tu-repo> ~/.dotfiles
cd ~/.dotfiles
./migrate.sh
```

El script `migrate.sh` soporta varias flags:

| Flag               | Descripción                                      |
| ------------------ | ------------------------------------------------ |
| `--skip-packages`  | Omite instalación de paquetes                    |
| `--skip-links`     | Omite creación de symlinks                       |
| `--skip-shell`     | Omite configuración de shell                     |
| `--dry-run`        | Solo muestra qué haría sin ejecutar nada         |
| `--snapshot-only`  | Solo genera snapshot del sistema actual           |

Los snapshots se guardan en `.snapshots/` e incluyen listas de paquetes pacman, AUR, cargo, servicios systemd, fuentes y más.

## 🤖 Para Agentes de IA

Si eres un agente de IA o colaborador, consulta [`AGENT.md`](./AGENT.md) para una descripción completa del entorno, convenciones, estructura y herramientas de este repositorio.

## ⚠️ Aviso

Estos son mis dotfiles personales. Están altamente personalizados para mi flujo de trabajo y mi máquina. Siéntete libre de usarlos, pero ten en cuenta que probablemente necesitarás hacer ajustes para que se adapten a tus propias necesidades.

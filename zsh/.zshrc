export ZSH="$HOME/.oh-my-zsh"

plugins=(
    git  
    zsh-syntax-highlighting 
    zsh-autosuggestions 
    fzf
    )

source $ZSH/oh-my-zsh.sh

# User configuration

# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

alias dcu="docker compose up"
alias dcd="docker compose down"
alias ls="eza --icons=always"

##Hist
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY

#fastfetch
fastfetch

eval "$(zoxide init zsh)"
export PATH=$PATH:$HOME/.local/bin
##pipx
export PATH=$PATH:$HOME

# startship
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"

# opencode
export PATH=$HOME/.opencode/bin:$PATH


# export local
# Cargar configuraciones locales (si existen)
if [ -f "$HOME/.zshrc.local" ]; then
    source "$HOME/.zshrc.local"
fi

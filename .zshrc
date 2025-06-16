# ZSH Config File
PROMPT=' %F{magenta}%/ %F{49}>%f '

# Path
export PATH="$HOME/.local/scripts:$PATH"
export XDG_DATA_DIRS="$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share:/usr/share"
export EDITOR="vim"
export VISUAL="vim"
export GTK_THEME=Tokyonight-Dark
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_DESKTOP=sway

# Aliases
alias ll='ls -al'
alias ps='ps aux'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'
alias status='systemctl list-units --type=service --state=running'
alias statusd='systemctl list-units --type=service --state=inactive,failed'

# Shell Commands
ii() {
    flatpak run org.gnome.eog "$@" > /dev/null 2>&1 &
}

# Plugins
source ~/.src/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.src/.zsh/zsh-completions/zsh-completions.zsh

fpath=(~/.src/.zsh/zsh-completions/src $fpath)

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY

fbset -g 2880 1800 2880 1800 32
clear
if [[ -n "$DISPLAY" || "$XDG_SESSION_TYPE" == "wayland" ]]; then
  # In GUI terminal
  fastfetch --logo-type sixel \
            --logo "$HOME/Pictures/Logos/debianlogop.png" \
            --logo-height 12 \
	    --logo-width 22 \
            --logo-padding-left 2 \
            --logo-padding-top 2 \
            --color-keys magenta \
            --title-color-user 36 \
            --title-color-host magenta
else
  # In TTY
  fastfetch --logo-type none \
            --color-keys magenta \
            --title-color-user 36 \
            --title-color-host magenta
fi


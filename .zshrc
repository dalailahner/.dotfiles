### ZSH CONFIG


## GENERAL

# history
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
# no beep
unsetopt beep
# line editing
bindkey -e


## ANTIOTE

# source antidote
source /home/$USER/.antidote/antidote.zsh
# readable names
zstyle ':antidote:bundle' use-friendly-names 'yes'
# init plugins
antidote load


## TOOLS

# FNM (Fast Node Manager)
export PATH=/home/$USER/.fnm:$PATH
eval "$(fnm env --shell zsh --use-on-cd --version-file-strategy=recursive)"
# pnpm
export PNPM_HOME="/home/dalailahner/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac


## ALIASES

# colored ls
alias ls="ls --color"
# pnpm
alias pn="pnpm"


## STARTUP
fastfetch

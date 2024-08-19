### ZSH CONFIG

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


## FNM (Fast Node Manager)

# setup
export PATH=/home/$USER/.fnm:$PATH
eval "$(fnm env --shell zsh --use-on-cd --version-file-strategy=recursive)"


## ALIASES

# colored ls
alias ls="ls --color"
alias pn="pnpm"

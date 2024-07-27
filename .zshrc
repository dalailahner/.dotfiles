## ZSH CONFIG

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
source ~/.antidote/antidote.zsh

# init plugins
antidote load


## ALIASES

# colored ls
alias ls="ls --color"

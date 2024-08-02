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


## NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

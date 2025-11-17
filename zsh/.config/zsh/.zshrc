### ZSH CONFIG


## ENVIRONMENT VARIABLES
export EDITOR=$(where micro | head -n 1)
export VISUAL=$(where micro | head -n 1)
# for winapps (actually for libvirt)
export LIBVIRT_DEFAULT_URI="qemu:///system"
eval `dircolors --bourne-shell ~/.config/zsh/.dir_colors`
if [[ "$TERM_PROGRAM" != "vscode" ]]; then
  export STARSHIP_CONFIG="$HOME/.config/starship/starship_default.toml"
else
  export STARSHIP_CONFIG="$HOME/.config/starship/starship_mini.toml"
fi

## COMPLETIONS

# commented out because zsh-autocomplete said so:
#autoload -Uz compinit
#compinit -d ~/.cache/zsh/.zcompdump
# pass the argument to compinit tho:
zstyle '*:compinit' arguments -d ~/.cache/zsh/.zcompdump

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' file-sort name
zstyle ':completion:*' format 'Suggesting: %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' ignore-parents parent ..
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list '+m:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select=1
zstyle ':completion:*' original false
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' verbose true
zstyle :compinstall filename "$ZDOTDIR/.zshrc"

## HISTORY
HISTFILE=~/.cache/zsh/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt appendhistory

## MISC SETTINGS
setopt autocd
setopt ignore_eof
unsetopt beep
bindkey -e
# fix for zsh-autocomplete
setopt interactive_comments


## KEYBINDINGS
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"
key[Control-Left]="${terminfo[kLFT5]}"
key[Control-Right]="${terminfo[kRIT5]}"

# setup key accordingly
[[ -n "${key[Home]}"          ]] && bindkey -- "${key[Home]}"          beginning-of-line
[[ -n "${key[End]}"           ]] && bindkey -- "${key[End]}"           end-of-line
[[ -n "${key[Insert]}"        ]] && bindkey -- "${key[Insert]}"        overwrite-mode
[[ -n "${key[Backspace]}"     ]] && bindkey -- "${key[Backspace]}"     backward-delete-char
[[ -n "${key[Delete]}"        ]] && bindkey -- "${key[Delete]}"        delete-char
[[ -n "${key[Up]}"            ]] && bindkey -- "${key[Up]}"            up-line-or-history
[[ -n "${key[Down]}"          ]] && bindkey -- "${key[Down]}"          down-line-or-history
[[ -n "${key[Left]}"          ]] && bindkey -- "${key[Left]}"          backward-char
[[ -n "${key[Right]}"         ]] && bindkey -- "${key[Right]}"         forward-char
[[ -n "${key[PageUp]}"        ]] && bindkey -- "${key[PageUp]}"        beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"      ]] && bindkey -- "${key[PageDown]}"      end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}"     ]] && bindkey -- "${key[Shift-Tab]}"     reverse-menu-complete
[[ -n "${key[Control-Left]}"  ]] && bindkey -- "${key[Control-Left]}"  backward-word
[[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}" forward-word

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi


## PLUGINS
autoload -Uz zmv
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh

export FZF_CTRL_T_OPTS="--walker-skip .git,node_modules,.cache,.wine,.steam,.local/share/Steam"
source <(fzf --zsh)
bindkey -r '^T'
bindkey '^F' fzf-file-widget
bindkey '^D' fzf-cd-widget

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"


## TOOLS

# gpg keys for git
export GPG_TTY=$(tty)

# yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# fnm
FNM_PATH="/home/$USER/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/home/$USER/.local/share/fnm:$PATH"
  eval "$(fnm env --shell zsh --use-on-cd --version-file-strategy=recursive)"
fi

# pnpm
export PNPM_HOME="/home/$USER/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac


## ALIASES

# colored grep
alias grep='grep --color=auto'
# colored diff
alias diff='diff --color'
# interactive and verbose copy
alias cp='cp -iv'
# interactive and verbose move
alias mv='mv -iv'
# use eza instead of ls
alias ls='eza'
# run background process (also works for firejail sandboxes)
runbg() {
  {
    "$@" > /dev/null 2>&1 &
  } &
}
# fnm
function fnm() {
  if [[ "$1" == "ls-all" ]]; then
    echo "- remote:\n..." && fnm ls-remote | tail -n 20 && echo "\n- local:" && fnm ls
  else
    command fnm "$@"
  fi
}
# pnpm
alias pn='pnpm'
alias pnx='pnpx'
# lazygit
alias lg='lazygit'


## STARTUP

# set wallpaper artist as env variable (for fastfetch)
if command -v qdbus6 > /dev/null; then
  wallpaper_uri=$(qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.wallpaper 0 | grep -oP 'file://\S+')
  wallpaper_basename=$(basename "${wallpaper_uri#file://}")
  wallpaper_artist=$(echo "$wallpaper_basename" | sed -nE 's/.+[^[:alnum:]]by[^[:alnum:]]([^.]+)\..+/\1/p')
  if [[ -n "$wallpaper_artist" ]]; then
    export WALLPAPER_ARTIST="${wallpaper_artist//_/ }"
  else  
    export WALLPAPER_ARTIST="unknown"
  fi
else  
  export WALLPAPER_ARTIST="unknown"
fi

# fastfetch
if [[ "$TERM_PROGRAM" != "vscode" ]]; then
  fastfetch
fi


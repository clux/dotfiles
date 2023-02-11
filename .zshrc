#!/bin/zsh

# If not running interactively, don't do anything
[[ $- == *i* ]] || return 0

# -----------------------------------------------------------------------------
# modules

eval "$(starship init zsh)" # prompt
eval "$(zoxide init zsh)" # directory jumping
source ~/.path
source ~/.functions
source ~/.exports
source ~/.aliases
source ~/.git-helpers
source ~/.k8s-helpers
[ -f ~/repos/bashlayer/bashrc ] && source ~/repos/bashlayer/bashrc

# -----------------------------------------------------------------------------
# completions

# generate comp file via exe ..varargs in ~/.zfunc/_exename
_gen_completion() {
    local -r exe="$1"
    if [ ! -e ~/.zfunc/_${exe} -a $commands[${exe}] ]; then
        mkdir -p ~/.zfunc
        ${exe} ${@:2} > ~/.zfunc/_${exe}
    fi
}
_gen_completion rustup completions zsh
_gen_completion kubectl completion zsh
_gen_completion helm completion zsh
_gen_completion just --completions zsh
_gen_completion k3d completion zsh
_gen_completion kopium completions zsh
#_gen_completion lal completions zsh
#_gen_completion shipcat completions zsh
_gen_completion procs --completion-out zsh
_gen_completion fd --gen-completions zsh

fpath+=~/.zfunc

autoload -Uz compinit && compinit
autoload bashcompinit && bashcompinit

# -----------------------------------------------------------------------------
# Key management via keychain

if [[ ${HOSTNAME} = "kjttks" ]]; then
  key github work main
elif [[ ${HOSTNAME} = "cluxm1.local" ]]; then
  key github work tl
else
  [ -f ~/.keychain/agent-sh ] && source ~/.keychain/agent-sh
  [ -f ~/.keychain/agent-sh-gpg ] && source ~/.keychain/agent-sh-gpg
fi

# -----------------------------------------------------------------------------
# History

# NB: history is accessed via key bindings in .inputrc
export HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
setopt HIST_IGNORE_DUPS # do not store duplications
setopt HIST_FIND_NO_DUPS # ignore duplicates when searching
setopt HIST_REDUCE_BLANKS # removes blank lines from history
export HISTSIZE=10000 # number of entries in memory
export HISTFILESIZE=${HISTSIZE} # number of lines in hist file
setopt APPEND_HISTORY # Append to history file, rather than overwriting it

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

# -----------------------------------------------------------------------------
# options

# Allow ** recursive globbing
#shopt -s globstar

unsetopt automenu # no auto-selections in auto-complete

bindkey -e
bindkey "^[[1;5C" forward-word  # CTRL right_arrow to move a word forward
bindkey "^[[1;5D" backward-word # CTRL left_arrow to move a word backward
bindkey '\e[3~'   delete-char

# -----------------------------------------------------------------------------
# colors

if [ -x /usr/bin/dircolors ] || [[ "${OSTYPE}" =~ "darwin" ]]; then
  export TERM="xterm-256color"

  # generate dircolors via vivid
  export LS_COLORS
  # Nord meshes well with rose-pine alacritty theme
  LS_COLORS="$(vivid generate nord)" # vivid theme
  # https://github.com/sharkdp/vivid/tree/master/themes

  # colored manpage theme through bat
  # https://github.com/sharkdp/bat/tree/master/assets/themes
  export MANPAGER="sh -c 'col -bx | bat -l man'"
fi

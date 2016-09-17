#!/bin/bash
export TERM=xterm-256color

# Modules
source ~/.promptline
source ~/.prompt
source ~/.functions
source ~/.exports
source ~/.aliases
source ~/.path

# work module
[ -f ~/repos/cisco/bashrc ] && source ~/repos/cisco/bashrc

# rupa/z + an extension
[ -f ~/local/z/z.sh ] && source ~/local/z/z.sh
# shellcheck disable=SC2068
d() {  z -l $@ | tail -n 1 | awk '{print $2}' ;}

# -----------------------------------------------------------------------------
# Key management via keychain

# NB: on debian we may need to run `keychain -k all` first
key() {
  local keys=""
  for k in "$@"; do
    keys="$keys $HOME/.ssh/${k}_id"
  done
  # shellcheck disable=SC2086
  keychain --timeout $((8*60)) --quiet --host agent $keys
  source ~/.keychain/agent-sh
}
_key() {
  local cur
  _init_completion || return
  local -r keys="$(find ~/.ssh -name "*_id" -printf "%f " | sed 's/_id//g')"
  COMPREPLY=($(compgen -W "$keys" -- "$cur"))
}
complete -F _key key

if [[ $(hostname) = ealbrigt-ws ]]; then
  key sqbu work
elif [[ $(hostname) = kjttks ]]; then
  key github main
elif [[ $(hostname) = cluxx1 ]]; then
  key github sqbu work
else
  [ -f ~/.keychain/agent-sh ] && source ~/.keychain/agent-sh
fi

# -----------------------------------------------------------------------------
# History

# NB: history is accessed via key bindings in .inputrc
export HISTCONTROL=ignoreboth:erasedupes
export HISTSIZE=5000 # number of entries in memory
export HISTFILESIZE=$HISTSIZE # number of lines in hist file
shopt -s histappend # Append to history file, rather than overwriting it

# -----------------------------------------------------------------------------
# Colors

if [ -x /usr/bin/dircolors ]; then
  [ -r ~/.dircolors ] && eval "$(dircolors -b ~/.dircolors)"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
  alias pacman='pacman --color=auto'

  man() {
    env \
      LESS_TERMCAP_mb="$(printf "\e[1;31m")" \
      LESS_TERMCAP_md="$(printf "\e[1;31m")" \
      LESS_TERMCAP_me="$(printf "\e[0m")" \
      LESS_TERMCAP_se="$(printf "\e[0m")" \
      LESS_TERMCAP_so="$(printf "\e[1;44;33m")" \
      LESS_TERMCAP_ue="$(printf "\e[0m")" \
      LESS_TERMCAP_us="$(printf "\e[1;32m")" \
      man "$@"
  }
fi

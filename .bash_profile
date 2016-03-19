#!/bin/bash
source ~/.prompt
source ~/.functions
source ~/.exports
source ~/.aliases
source ~/.path

# directory jumping shortcut
source ~/local/z/z.sh

# absorb keychain managed keys
if [ "$(hostname)" = "ealbrigt-ws" ]; then
  key sqbu work
elif [ "$(hostname)" = "kjttks" ]; then
  key github main
else
  [ -f ~/.keychain/agent-sh ] && source ~/.keychain/agent-sh
fi

# Case-insensitive globbing (used in pathname expansion)
#shopt -s nocaseglob

# Autocorrect typos in path names when using `cd`
#shopt -s cdspell

# History
export HISTCONTROL=ignoreboth:erasedupes
export HISTSIZE=5000 # number of entries in memory
export HISTFILESIZE=5000 # number of lines in hist file
shopt -s histappend # Append to history file, rather than overwriting it

# Set custom colours in folders and add defaults to common commands
if [ -x /usr/bin/dircolors ]; then
  [ -r ~/.dircolors ] && eval "$(dircolors -b ~/.dircolors)"
  alias ls='ls --color=auto'
  alias dir='dir --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
  alias pacman='pacman --color=auto'
fi

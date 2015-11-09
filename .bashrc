# Always have PATH fully set for non-interactive shells
[ -f ~/.path ] && source ~/.path

# If not running interactively, don't do anything
[[ $- == *i* ]] || return 0

# Append to history rather than overwriting it
shopt -s histappend

# Set custom colours in folders and add defaults to common commands
if [ -x /usr/bin/dircolors ]; then
  [ -r ~/.dircolors ] && eval "$(dircolors -b ~/.dircolors)"
  alias ls='ls --color=auto'
  alias dir='dir --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

[ -f ~/.bash_profile ] && source ~/.bash_profile

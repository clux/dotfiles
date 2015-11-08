# Always have PATH fully set for non-interactive shells
[ -f ~/.path ] && source ~/.path

# If not running interactively, don't do anything
[[ $- == *i* ]] || return 0

# Append to history
shopt -s histappend

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  (test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)") || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias dir='dir --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

[ -f ~/.bash_profile ] && source ~/.bash_profile

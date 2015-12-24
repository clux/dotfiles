# Always have PATH fully set for non-interactive shells
[ -f ~/.path ] && source ~/.path

# If not running interactively, don't do anything
[[ $- == *i* ]] || return 0

# If running under guake, also run under tmux
if [[ $PPID == $(pgrep -f guake) ]]; then
  exec tmux
fi

[ -f ~/.bash_profile ] && source ~/.bash_profile

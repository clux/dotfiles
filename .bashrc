# If not running interactively, don't do anything
[[ $- == *i* ]] || return 0

[ -f ~/.bash_profile ] && source ~/.bash_profile

# If running under guake, also run under tmux
which tmux > /dev/null || return 0
if [[ $PPID == $(pgrep -f guake) ]]; then
  guakeIndex=$(guake -g)
  if tmux list-sessions | cut -d':' -f1 | grep -q "$guakeIndex"; then
    # use one of the preconfigured sessions
    exec tmux attach-session -t "$guakeIndex"
  else
    exec tmux new-session
  fi
fi

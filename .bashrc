# If not running interactively, don't do anything
[[ $- == *i* ]] || return 0

[ -f ~/.bash_profile ] && source ~/.bash_profile


[ -f ~/.fzf.bash ] && source ~/.fzf.bash

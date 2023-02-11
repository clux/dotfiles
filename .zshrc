#!/bin/zsh

# If not running interactively, don't do anything
[[ $- == *i* ]] || return 0

# -----------------------------------------------------------------------------
# modules

eval "$(starship init zsh)" # prompt
eval "$(zoxide init zsh)" # directory jumping
source ~/.functions
source ~/.exports
source ~/.aliases
source ~/.git-helpers
source ~/.k8s-helpers
[ -f ~/repos/bashlayer/bashrc ] && source ~/repos/bashlayer/bashrc

# -----------------------------------------------------------------------------
# completions

# generate comp file via exe ..varargs in ~/.zfunc/_exename
_gencmp() {
    local -r exe="$1"
    if [ ! -e ~/.zfunc/_${exe} -a $commands[${exe}] ]; then
        mkdir -p ~/.zfunc
        ${exe} ${@:2} > ~/.zfunc/_${exe}
    fi
}
_gencmp rustup completions zsh
_gencmp kubectl completion zsh
_gencmp helm completion zsh
_gencmp just --completions zsh
_gencmp k3d completion zsh
_gencmp procs --completion-out zsh
_gencmp fd --gen-completions zsh
_gencmp kopium completions zsh
#_gencmp lal completions zsh
#_gencmp shipcat completions zsh

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

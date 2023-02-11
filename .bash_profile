#!/bin/bash
# Allow ** recursive globbing
shopt -s globstar

# Main modules
source ~/.path

if [[ "${OSTYPE}" =~ "darwin" ]]; then # auto-sourced on linux
  source ~/.bash_completion
fi

# Prompt

## Alternative 1: bash specific 200 line script
#source ~/.prompt
## Alternative 2: shell agnostic 100 line toml cfg (from a 20k line rust bin)
eval "$(starship init bash)"

source ~/.functions
source ~/.exports
source ~/.aliases
source ~/.git-helpers
source ~/.k8s-helpers

# rupa/z replacement
eval "$(zoxide init bash)"

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
[ -f ~/repos/bashlayer/bashrc ] && source ~/repos/bashlayer/bashrc

# -----------------------------------------------------------------------------
# History

# NB: history is accessed via key bindings in .inputrc
export HISTCONTROL=ignoreboth:erasedupes
export HISTSIZE=10000 # number of entries in memory
export HISTFILESIZE=${HISTSIZE} # number of lines in hist file
shopt -s histappend # Append to history file, rather than overwriting it

# HSTR configuration (defaults that didn't match my existing ones)
alias hh=hstr                    # hh to be alias for hstr
export HSTR_CONFIG=hicolor       # get more colors
# if this is interactive shell, then bind hstr to Ctrl-r (for Vi mode check doc)
if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hstr -- \C-j"'; fi
# if this is interactive shell, then bind 'kill last command' to Ctrl-x k
if [[ $- =~ .*i.* ]]; then bind '"\C-xk": "\C-a hstr -k \C-j"'; fi

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

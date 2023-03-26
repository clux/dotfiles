#!/bin/zsh

# If not running interactively, don't do anything
[[ $- == *i* ]] || return 0

# If running in zellij on linux, save the window for refocus keybinds
if [ -n "${ZELLIJ_SESSION_NAME}" ] && [ ! -f /tmp/wraise ]; then
  xdotool getactivewindow > /tmp/wraise
  # F2 keybind in cinnamon hits toggle_terminal
  # Mac uses Hammerspoon to do the same thing
fi

# -----------------------------------------------------------------------------
# modules

eval "$(starship init zsh)" # prompt
eval "$(zoxide init zsh)" # directory jumping
source ~/.functions
source ~/.aliases
source ~/.git-helpers
source ~/.k8s-helpers
[ -f ~/repos/bashlayer/bashrc ] && source ~/repos/bashlayer/bashrc

# Nord meshes well with rose-pine alacritty theme
# https://github.com/sharkdp/vivid/tree/master/themes
export EXA_COLORS="$(vivid generate nord)" # theme for exa
export LS_COLORS="$(vivid generate dracula)" # theme for autocomplete

# -----------------------------------------------------------------------------
# autocomplete

if [[ "${OSTYPE}" =~ "darwin" ]]; then
  eval "$(brew shellenv)"
  # load completions from brew installed packages via zsh-completions
  fpath+=$HOMEBREW_PREFIX/share/zsh/site-functions
  # initialize z plugin manager zinit
  source $HOMEBREW_PREFIX/opt/zinit/zinit.zsh 2> /dev/null # ignore manpage issue for now
else
  source /usr/share/zinit/zinit.zsh
fi

# custom completions - generate comp file for misc executables in ~/.zfunc/_bin
_gencmp() {
  # only need to do this for out-of-band installations due to standard fpath above
  # NB: kill ~/.zcompdump if something is not working
  local -r bin="$1"
  if [ ! -e ~/.zfunc/_${bin} -a $commands[${bin}] ]; then
    mkdir -p ~/.zfunc
    ${@:2} > ~/.zfunc/_${bin}
  fi
}
_gencmp kopium kopium completions zsh
_gencmp rustup rustup completions zsh
_gencmp cargo rustup completions zsh cargo
fpath+=~/.zfunc

# load completion, with bash compat
autoload -Uz compinit && compinit
autoload bashcompinit && bashcompinit

# addons from zinit
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting

# configure autosuggestions; avoid suggesting directories, but otherwise favour history
ZSH_AUTOSUGGEST_HISTORY_IGNORE="cd *"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
bindkey '^[[Z' autosuggest-accept # shift-tab for suggestions, tab for completions
# NB: can use up-arrow to partially accept due to how it interacts with history and thus fuzzy search below

# general autocomplete configuration
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:*:*:*' menu select
zstyle :compinstall filename "$HOME/.zshrc"

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

# Fuzzy find cycle through history on up / down based on starting cursor location
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # key_up / kcuu1
bindkey "^[[B" down-line-or-beginning-search # key_down / kcud1

# -----------------------------------------------------------------------------
# Movement

bindkey "^[[1;5C" forward-word  # ctrl + right_arrow to move a word forwards
bindkey "^[[1;5D" backward-word # ctrl + left_arrow to move a word backwards
# on linux we can have backward-delete-word on modifire-backspace but hard on mac

# defaults:
# ctrl-w is delete word (werase)
# ctrl-a go to start of line
# ctrl-e go to end of line

# Remove / from WORDCHARS to allow word movement to respect slash as a boundary (better for paths)
export WORDCHARS="${WORDCHARS:s@/@}"

# -----------------------------------------------------------------------------
# Key management via keychain

if [[ ${HOSTNAME} = "kjttks" ]]; then
  key github work main
elif [[ $(hostname) = "cluxm1.local" ]]; then
  key github work tl
else
  [ -f ~/.keychain/agent-sh ] && source ~/.keychain/agent-sh
  [ -f ~/.keychain/agent-sh-gpg ] && source ~/.keychain/agent-sh-gpg
fi

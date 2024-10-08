#!/bin/zsh

# If not running interactively, don't do anything
[[ $- == *i* ]] || return 0

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
  # needs to be done before the autoload it appears
  fpath+=$HOMEBREW_PREFIX/share/zsh/site-functions
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
#_gencmp kopium kopium completions zsh
_gencmp rustup rustup completions zsh
_gencmp cargo rustup completions zsh cargo
fpath+=~/.zfunc

# load completion, with bash compat
autoload -Uz compinit && compinit
autoload bashcompinit && bashcompinit

if [[ "${OSTYPE}" =~ "darwin" ]]; then
  source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
else
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

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

# unbind regular history search - frees up some zellij binds
# NB: bindkey lists existing bindings, /bin/cat -v show produced codes
bindkey -r "^R" # history-incremental-search-backward
bindkey -r "^S" # history-incremental-search-forward
bindkey -r "^Xr" # history-incremental-search-backward
bindkey -r "^Xs" # history-incremental-search-forward

# -----------------------------------------------------------------------------
# Movement

bindkey "^[[1;5C" forward-word  # ctrl + right_arrow to move a word forwards
bindkey "^[[1;5D" backward-word # ctrl + left_arrow to move a word backwards
# NB: deleting words is alt-backspace and alt-d
# Fullsize keyboard binds:
bindkey  "^[[3~"  delete-char   # delete key to delete forwards (mac has fn-backspace)
bindkey  "^[[H"   beginning-of-line # HOME == alternate ctrl-a
bindkey  "^[[F"   end-of-line # END alternate ctrl-e

# defaults that work in alacritty cross-os:
# ctrl-w is delete word (werase)
# ctrl-a go to start of line
# ctrl-e go to end of line

# NB: currently impossible to bind ctrl-backspace to delete-word-backwards in mac
# so moving with ctrl (to avoid clashing with zellij which cannot use ctrl-left)
# See https://github.com/zellij-org/zellij/issues/735
# and deleting with alt-backspace (this also matches the helix config)

# Remove / and = from WORDCHARS to allow word movement to respect these as a boundaries
export WORDCHARS="${${WORDCHARS:s@/@}:s@=@}"

# -----------------------------------------------------------------------------
# Key management via keychain

if [[ ${HOST} = "hprks" ]]; then
  key github main
elif [[ "${OSTYPE}" =~ "darwin" ]]; then
  key github work tl
else
  [ -f ~/.keychain/agent-sh ] && source ~/.keychain/agent-sh
  [ -f ~/.keychain/agent-sh-gpg ] && source ~/.keychain/agent-sh-gpg
fi

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
if [[ "${OSTYPE}" =~ "darwin" ]]; then
  source /opt/homebrew/opt/zinit/zinit.zsh 2> /dev/null # ignore manpage issue for now
  eval "$(brew shellenv)"
  fpath+=$HOMEBREW_PREFIX/share/zsh/site-functions
fi

# Nord meshes well with rose-pine alacritty theme
# https://github.com/sharkdp/vivid/tree/master/themes
export EXA_COLORS="$(vivid generate nord)" # vivid theme for exa
export LS_COLORS="$(vivid generate dracula)" # for autocomplete

# -----------------------------------------------------------------------------
# completions

setopt automenu # auto-selections in auto-complete

# generate comp file for bin via vararg cmd in ~/.zfunc/_bin
# only need to do this for out-of-band installations due to fpath above
# NB: kill ~/.zcompdump if something is not working
_gencmp() {
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

autoload -Uz compinit && compinit
autoload bashcompinit && bashcompinit

zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting

# avoid auto suggesting directories, but otherwise favour history
ZSH_AUTOSUGGEST_HISTORY_IGNORE="cd *"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
bindkey '^[[Z' autosuggest-accept # shift-tab for suggestions, tab for completions

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

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

# -----------------------------------------------------------------------------
# options

# Allow ** recursive globbing
setopt GLOB_STAR_SHORT

bindkey -e
bindkey "^[[1;5C" forward-word  # CTRL right_arrow to move a word forward
bindkey "^[[1;5D" backward-word # CTRL left_arrow to move a word backward
bindkey '\e[3~'   delete-char

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

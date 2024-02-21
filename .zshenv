#!/bin/zsh

export EDITOR="hx"
export TERM="xterm-256color"

# colored manpage theme through bat
export MANPAGER="sh -c 'col -bx | bat -l man'"
export MANROFFOPT='-c' # https://github.com/sharkdp/bat/issues/2593

# use shellcheck for current file only
export SHELLCHECK_OPTS="-e SC1091 -e SC1090"

# openkeychain compat
export PASSWORD_STORE_GPG_OPTS='--no-throw-keyids'

# fzf should ony show non-build files when browsing git repos
# Verify with echo $FZF_DEFAULT_COMMAND | sh | fzf
export FZF_DEFAULT_COMMAND='
  (git ls-tree -r --name-only HEAD ||
   find . -type f -print -o -type l -print |
      grep -vE "/target/|node_modules|bower_components|venv\/|.git/" |
      sed s/^..//) 2> /dev/null'
_FZF_LAYOUT='--height 50% --layout=reverse'
# fzf theme; catppuccin mocha: https://github.com/catppuccin/fzf but no bg
export FZF_DEFAULT_OPTS="${_FZF_LAYOUT} \
--color=spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

# Prefer GB English and use UTF-8
export LANG="en_GB.UTF-8"
export LC_ALL="en_GB.UTF-8"

# want short ctest results without having to type --output-on-failure (or -V always)
export CTEST_OUTPUT_ON_FAILURE=1
export GTEST_COLOR=1

# Always print rust backtraces
export RUST_BACKTRACE=1

# go
export GOPATH=$HOME/.go
export GO111MODULE=on

# disable analytics sending to homebrew
export HOMEBREW_NO_ANALYTICS=1

# -----------------------------------------------------------------------------
# PATH

# remove duplicate entries from PATH and MANPATH
typeset -U path PATH manpath MANPATH

# standard package locations
path+=/usr/local/bin
path+=$HOME/.cargo/bin
path+=$HOME/.local/bin
path+=$GOPATH/bin
path+=/opt/homebrew/bin

# The macos compatibility shitshow
if [[ "${OSTYPE}" =~ "darwin" ]]; then
  # No good universal way to get coreutils installed without g prefix.
  # (and doing so can apparently break python builds)
  # We can extend PATH into certain pkgs (where g-less bins sometimes exist),
  # or alias to g-less prefixes, but manpages cannot rely on this:
  # e.g. sources; /opt/homebrew/share/man/man1/g or Cellar/coreutils/*/share/man/man1
  # => we cannot type "man rm" no matter what, have to type "man grm".
  # we can however fix: make, gnu-sed, gnu-tar, grep via MANPATH patching + aliases:
  manpath+=/opt/homebrew/opt/make/libexec/man
  manpath+=/opt/homebrew/opt/grep/libexec/man
  manpath+=/opt/homebrew/opt/gnu-tar/libexec/man
  manpath+=/opt/homebrew/opt/gnu-sed/libexec/man
  alias sed=gsed
  alias grep=ggrep
  alias sed=gsed
  alias make=gmake
  # and make most coreutils appear working (but man pages need g prefix)
  alias date=gdate
  alias rm=grm
  alias awk=gawk
  # for multiple bins in binutils, findutils, simple PATH extension is enough:
  path+=/opt/homebrew/opt/binutils/bin
  path+=/opt/homebrew/opt/findutils/libexec/gnubin

  # other common linux tools need just brew packages to get updated;
  # brew install watch diffutils rsync bash gpatch less
  # alternatively; cargo install coreutils and alias head="coreutils head"
  # TODO: in the future try out the rust rewrite https://github.com/uutils/coreutils

  # oh, and no ps, so try to move to procs:
  alias ps=procs

  # python on mac is also fun
  path+="$(python3 -m site --user-base)/bin"
  export HOSTNAME="$(scutil --get LocalHostName)"
fi

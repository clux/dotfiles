#!/bin/zsh

export EDITOR="hx"
export TERM="xterm-256color"

# colored manpage theme through bat
export MANPAGER="sh -c 'col -bx | bat -l man'"
export MANROFFOPT='-c' # https://github.com/sharkdp/bat/issues/2593

# openkeychain compat
export PASSWORD_STORE_GPG_OPTS='--no-throw-keyids'

# fzf for file search should exclude git ignored files
export FZF_DEFAULT_COMMAND="fd --strip-cwd-prefix -HE='.git'"
export FZF_ALT_C_COMMAND="fd --type d --strip-cwd-prefix -HE='.git'"
# for tab completion on **
_fzf_compgen_path() {  fd -HE='.git' . "$1"; }
_fzf_compgen_gir() { fd --type=d -HE='.git' . "$1"; }
_FZF_LAYOUT='--height 50% --layout=reverse'
#eval "$(fzf --zsh)"

# fzf theme; catppuccin mocha: https://github.com/catppuccin/fzf but no bg
export FZF_DEFAULT_OPTS="${_FZF_LAYOUT} \
--color=spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

# Prefer GB English and use UTF-8
export LANG="en_GB.UTF-8"
export LC_ALL="en_GB.UTF-8"

# -----------------------------------------------------------------------------
# Development settings

# shellcheck current file only in editor
export SHELLCHECK_OPTS="-e SC1091 -e SC1090"

# Always print rust backtraces
export RUST_BACKTRACE=1

# -----------------------------------------------------------------------------
# Disable history from less used stuff

# https://man7.org/linux/man-pages/man1/less.1.html
export LESSHISTFILE="-"
# https://nodejs.org/api/repl.html#environment-variable-options
export NODE_REPL_HISTORY=""
# https://docs.python.org/3/library/site.html#readline-configuration
export PYTHONSTARTUP="${HOME}/.config/python/startup.py"

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

# -----------------------------------------------------------------------------
# The macos compatibility shitshow

if [[ "${OSTYPE}" =~ "darwin" ]]; then
  # Fix modern coreutils/uutils without g (gnu) or u (uutils) prefix.
  # (doing so can apparently break python builds, so doing in here for user only)
  # Bin paths for uutils (also sufficient to resolve manpaths now)
  PATH="/opt/homebrew/opt/uutils-coreutils/libexec/uubin:$PATH"
  # findutils from gnu has a good gnubin with man pages
  PATH="/opt/homebrew/opt/findutils/libexec/gnubin:$PATH"
  # NB: not doing findutils from uutils yet, alpha find.
  # maybe later do variation of:
  # PATH="/opt/homebrew/opt/uutils-findutils/libexec/uubin:$PATH"
  # MANPATH="/opt/homebrew/opt/uutils-coreutils/libexec/uuman:$MANPATH"

  # Then stragglers; sed,grep,make,patch,awk (gnubins all have man dirs o/)
  PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"
  PATH="/opt/homebrew/opt/grep/libexec/gnubin:$PATH"
  PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"
  PATH="/opt/homebrew/opt/gpatch/libexec/gnubin:$PATH"
  PATH="/opt/homebrew/opt/gawk/libexec/gnubin:$PATH"

  # NB: mac also reverses the PATH, tried .zprofile, but found .zshenv to be more reliable
  # ref: https://gist.github.com/Linerre/f11ad4a6a934dcf01ee8415c9457e7b2

  # other common linux tools need just brew packages to get updated;
  # brew install watch diffutils rsync bash less

  # oh, and no ps, so try to move to procs:
  alias ps=procs

  # python on mac is also fun
  path+="$(python3 -m site --user-base)/bin"

  # Consistent hostname var polyfill for scripts
  # NB: HOST is zsh, HOSTNAME is bash
  export HOSTNAME="$(scutil --get LocalHostName)"

  # disable analytics sending to homebrew
  export HOMEBREW_NO_ANALYTICS=1
fi

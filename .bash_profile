#!/bin/bash

for file in ~/{.bash_prompt,.exports,.aliases,.functions,.extra}; do
  # shellcheck source=/dev/null
  [ -f "$file" ] && source "$file"
done
unset file

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

source ~/local/z/z.sh

# Add tab completion for SSH hostnames based on ~/.ssh/config
[ -e "$HOME/.ssh/config" ] || touch $HOME/.ssh/config
complete -o "default" \
  -o "nospace" \
  -W "$(grep "^Host" ~/.ssh/config | \
  grep -v "[?*]" | cut -d " " -f2 | \
  tr ' ' '\n')" scp sftp ssh

#!/bin/bash

for file in ~/.{bash_prompt,aliases,functions,path,extra,exports}; do
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

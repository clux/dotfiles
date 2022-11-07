# See https://just.systems/man/
SHELLCHECK_OPTS := "-e SC1091 -e SC1090 -e SC1117 -s bash"

default:
  @just --list --unsorted --color=always | rg -v "    default"

# create all home subdirectories before symlinking into them
directories:
  mkdir -p ~/.config/{autostart,profanity,sublime-text-3/{Local,Packages}}
  mkdir -p ~/.templates/{git/hooks}
  mkdir -p ~/{.mpd/playlists,.ncmpcpp,.jira.d,Music}

# create directories and create symlinks pointing to this repo checkout
config: directories
  #!/bin/bash
  echo "linking configs in $HOME"
  find "$PWD" -maxdepth 1 -name ".*" -type f -print -exec ln -sfn {} ~/ \;
  echo "Linking config subdirectories of $HOME"
  for d in {.config{,/profanity,/alacritty,/karabiner},.templates/git/hooks,.ncmpcpp,.jira.d}; do\
    echo $d
    find "$PWD/$d" -maxdepth 1 -type f -print -exec ln -sfn {} ~/$d \;
  done
  touch ~/.bash_completion

# configure code editors
editors: directories
  echo "configuring sublime and installing vim plugins"
  @[ -d ~/.config/sublime-text-3/Packages/User ] || make sublime_user
  @[ -f ~/.config/sublime-text-3/Local/License.sublime_license ] || make sublime_license
  @[ -d ~/.vim/plugged ] || make vim


# link sublime 3 license
sublime_license:
  pass sublime > ~/.config/sublime-text-3/Local/License.sublime_license
# link sublime 3 user config
sublime_user:
  ln -s "$PWD/.config/sublime-text-3/Packages/User" ~/.config/sublime-text-3/Packages/User  

# install vim plugins
vim:
  [ -f ~/.vim/autoload/plug.vim ] && vim +PlugUpdate +qall

# font guard (linux only)
has_fonts:
  echo "Guarding on Liberations + powerline font presence"
  @find /usr/share/fonts/ | grep -q Liberation
  #@find ~/.local/share/fonts/ | grep -q Powerline
  @find /usr/share/fonts/ | grep -q Powerline

# configure dconf on linux
dconf: has_fonts
  echo "Importing dconf settings"
  dconf load /org/ < org.dconf
  dconf load /apps/ < apps.dconf

# restore config managed gui profiles
ui: dconf

# run local shellcheck lint
lint:
  #!/bin/bash
  SHELLCHECK_OPTS="{{SHELLCHECK_OPTS}}" shellcheck .aliases .exports .bashrc .bash_completion .bash_profile .path .prompt .functions .xprofile .githelpers

# run shellcheck lint via docker
lint-docker:
  docker run \
    -e SHELLCHECK_OPTS="{{SHELLCHECK_OPTS}}" \
    -v $$PWD:/volume -w /volume \
    -t koalaman/shellcheck:stable \
    shellcheck .aliases .exports .bashrc .bash_completion .bash_profile .path .prompt .functions .xprofile .githelpers

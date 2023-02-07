# See https://just.systems/man/
SHELLCHECK_OPTS := "-e SC1091 -e SC1090 -e SC1117 -s bash"
SHELLCHECKED_FILES := ".aliases .exports .bashrc .bash_completion .bash_profile .path .prompt .functions .xprofile .git-helpers .k8s-helpers .templates/git/hooks/*"
VSCODE_PATH := if os() == "macos" { "~/Library/Application\\ Support" } else { "~/.config" }

default:
  @just --list --unsorted --color=always | rg -v "    default"

# create all home subdirectories before symlinking into them
directories:
  mkdir -p ~/.config/{autostart,helix}
  mkdir -p ~/.templates/git/hooks
  mkdir -p ~/Music

# create directories and create symlinks pointing to this repo checkout
config: directories
  #!/bin/bash
  echo "linking configs into $HOME"
  find "$PWD" -maxdepth 1 -name ".*" -type f -print -exec ln -sfn {} ~/ \;
  echo "Linking .config/{subdir}/files*"
  for d in {.config{,/helix,/alacritty,/karabiner},.templates/git/hooks}; do\
    echo $d
    find "$PWD/$d" -maxdepth 1 -type f -print -exec ln -sfn {} ~/$d \;
  done
  echo "Linking .config/{subdirs}"
  ln -sfn $PWD/.config/zellij ~/.config/
  ln -sfn $PWD/.config/bat ~/.config/
  echo "Linking special cases"
  ln -sfn $PWD/.hammerspoon ~/
  echo "Refresh"
  just reload-configs

# reload configs and themes in tools that have a command for it
reload-configs:
  touch ~/.bash_completion
  bat cache --build
  zellij setup --check

# install vs code plugins
vscode:
  #!/bin/bash
  ln -sfn $PWD/vscode/settings.json {{VSCODE_PATH}}/Code/User/settings.json
  cat vscode/extensions | xargs -n 1 code --install-extension
  cat vscode/themes | xargs -n 1 code --install-extension

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
ui: dconf vscode

# run local shellcheck lint
lint:
  #!/bin/bash
  SHELLCHECK_OPTS="{{SHELLCHECK_OPTS}}" shellcheck {{SHELLCHECKED_FILES}}

# run shellcheck lint via docker
lint-docker:
  docker run \
    -e SHELLCHECK_OPTS="{{SHELLCHECK_OPTS}}" \
    -v $$PWD:/volume -w /volume \
    -t koalaman/shellcheck:stable \
    shellcheck {{SHELLCHECKED_FILES}}

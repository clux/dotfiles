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
config: directories has_fonts
  #!/bin/bash
  echo "linking dot prefixed config files into $HOME"
  fd -g '.*' -H --max-depth 1 --type f -a -x ln -sfn {} ~/
  echo "Linking any immediate child dir/file of .config into $HOME/.config/"
  fd --base-directory .config/ --max-depth 1 -a -x ln -sfn {} ~/.config/
  just reload-configs

# reload configs and themes in tools that have a command for it
reload-configs:
  echo "Refreshing dependencies"
  touch ~/.bash_completion
  bat cache --build
  zellij setup --check

# install vs code plugins
vscode:
  #!/bin/bash
  ln -sfn $PWD/vscode/settings.json {{VSCODE_PATH}}/Code/User/settings.json
  cat vscode/extensions | xargs -n 1 code --install-extension
  cat vscode/themes | xargs -n 1 code --install-extension

# font guard (linux)
[linux]
has_fonts:
  echo "Guarding on Linux font setup: Liberation + Inconsolata"
  fd . /usr/share/fonts/ -e ttf | rg -q Liberation
  fd . /usr/share/fonts/ -e ttf | rg -q Powerline
  fd . /usr/share/fonts/  -e ttf | rg -q "Inconsolata.*Mono"

# font guard (mac)
[macos]
has_fonts:
  echo "Guarding on Mac font setup: Inconsolata Mono"
  fd . ~/Library/Fonts/ -e ttf | rg -q "Inconsolata.*Mono"

# configure dconf on linux
[linux]
dconf: has_fonts
  echo "Importing dconf settings"
  dconf load /org/ < org.dconf
  dconf load /apps/ < apps.dconf

# restore config managed gui profiles
[linux]
ui: dconf vscode

# restore config managed gui profiles (mac)
[macos]
ui: vscode
  ln -sfn $PWD/.hammerspoon ~/

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

# mode: makefile
# End:
# vim: set ft=make :

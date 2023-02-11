# See https://just.systems/man/
SHELLCHECK_OPTS := "-e SC1091 -e SC1090 -e SC1117 -s bash"
SHELLCHECKED_FILES := ".aliases .exports .path .functions .xprofile .git-helpers .k8s-helpers git/hooks/* defaults.sh"
VSCODE_PATH := if os() == "macos" { "~/Library/Application\\ Support" } else { "~/.config" }

[private]
default:
  @just --list --unsorted

# create symlinks pointing to this repo checkout
config: fontguard
  #!/bin/bash
  echo "linking dot prefixed config files into $HOME"
  fd -g '.*' -H --max-depth 1 --type f -a -x ln -sfn {} ~/
  echo "Linking any immediate child dir/file of config into $HOME/.config/"
  fd --base-directory config/ --max-depth 1 -a -x ln -sfn {} ~/.config/
  just reload

# reload configs and themes via trigger commands
reload:
  echo "Refreshing dependencies that need to be told about changes"
  touch ~/.bash_completion
  bat cache --build
  zellij setup --check

# install vs code plugins
vscode:
  #!/bin/bash
  ln -sfn $PWD/vscode/settings.json {{VSCODE_PATH}}/Code/User/settings.json
  cat vscode/extensions | xargs -n 1 code --install-extension
  cat vscode/themes | xargs -n 1 code --install-extension

# font guard helper (linux)
[linux]
fontguard:
  echo "Guarding on Linux font setup: Liberation + Inconsolata"
  fd . /usr/share/fonts/ -e ttf | rg -q Liberation
  fd . /usr/share/fonts/ -e ttf | rg -q Powerline
  fd . /usr/share/fonts/ -e ttf | rg -q "Inconsolata.*Mono"

# font guard helper (mac)
[macos]
fontguard:
  echo "Guarding on Mac font setup: Inconsolata Mono"
  fd . ~/Library/Fonts/ -e ttf | rg -q "Inconsolata.*Mono"

# configure system properties (linux)
[linux]
system: fontguard vscode
  echo "Importing dconf settings"
  dconf load /org/ < org.dconf
  dconf load /apps/ < apps.dconf

# configure system properties (mac)
[macos]
system: vscode
  ./defaults.sh

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

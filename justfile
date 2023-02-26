# See https://just.systems/man/
SHELLCHECK_OPTS := "-e SC1091 -e SC1090 -e SC1117 -s bash"
SHELLCHECKED_FILES := ".aliases .zshenv .functions .xprofile .git-helpers .k8s-helpers git/hooks/* defaults.sh"
CONFIG_HOME := if os() == "macos" { "~/Library/Application\\ Support" } else { "~/.config" }

[private]
default:
  @just --list --unsorted

# create symlinks pointing to this repo checkout
config: fontguard
  fd -g '.*' -H --max-depth 1 --type f -a -x ln -sfn {} ~/
  fd --base-directory config/ --max-depth 1 -a -x ln -sfn {} ~/.config/
  ln -sfn $PWD/vscode/settings.json {{CONFIG_HOME}}/Code/User/settings.json
  ln -sfn $PWD/share/k9s {{CONFIG_HOME}}/k9s

# install vs code plugins
vscode:
  cat vscode/extensions | xargs -n 1 code --install-extension
  cat vscode/themes | xargs -n 1 code --install-extension

# font guard helper (linux)
[linux]
fontguard:
  fd . /usr/share/fonts/ -e ttf | rg -q Liberation
  fd . /usr/share/fonts/ -e ttf | rg -q Powerline
  fd . /usr/share/fonts/ -e ttf | rg -q "Inconsolata.*Mono"

# font guard helper (mac)
[macos]
fontguard:
  fd . ~/Library/Fonts/ -e ttf | rg -q "Inconsolata.*Mono"

# configure system properties (linux)
[linux]
system: fontguard vscode
  dconf load /org/ < org.dconf
  dconf load /apps/ < apps.dconf

# configure system properties (mac)
[macos]
system: vscode
  ./defaults.sh

# reload configs insofar as possible
reload:
  bat cache --build | rg -v "okay"
  killall SystemUIServer || true
  killall Finder || true

# run local shellcheck lint
lint:
  SHELLCHECK_OPTS="{{SHELLCHECK_OPTS}}" shellcheck {{SHELLCHECKED_FILES}}
  zellij setup --check > /dev/null

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

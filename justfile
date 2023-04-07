# See https://just.systems/man/
SHELLCHECK_OPTS := "-e SC1091 -e SC1090 -e SC1117 -s bash"
SHELLCHECKED_FILES := ".aliases .zshenv .functions .xprofile .git-helpers .k8s-helpers git/hooks/* defaults.sh"
CONFIG_HOME := if os() == "macos" { "~/Library/Application\\ Support" } else { "~/.config" }

[private]
default:
  @just --list --unsorted

# create symlinks pointing to this repo checkout
link: fontguard
  # Dot prefixed files are linked to from $HOME
  fd -g '.*' -H --max-depth 1 --type f -a -x ln -sfn {} ~/
  # Children of config are linked to from $HOME/.config
  fd --base-directory config/ --max-depth 1 -a -x ln -sfn {} ~/.config/
  # Children of share are linked to from platform specific {{CONFIG_HOME}}
  fd --base-directory share/ --max-depth 1 --no-ignore-vcs -a -x ln -sfn {} {{CONFIG_HOME}}/

# font guard helper (linux)
[linux]
fontguard:
  fd . /usr/share/fonts/ -e ttf | rg -q Liberation
  fd . /usr/share/fonts/ -e ttf | rg -q "Inconsolata.*Mono"

# font guard helper (mac)
[macos]
fontguard:
  fd . ~/Library/Fonts/ -e ttf | rg -q "Inconsolata.*Mono"

# configure system properties (linux)
[linux]
system: fontguard
  dconf load /org/ < org.dconf
  ln -sf $PWD/config/alacritty/linux.yml config/alacritty/os.yml

# configure system properties (mac)
[macos]
system:
  ./defaults.sh
  ln -sf $PWD/config/alacritty/mac.yml config/alacritty/os.yml

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

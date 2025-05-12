# See https://just.systems/man/
SHELLCHECK_OPTS := "-e SC1091 -e SC1090 -e SC1117 -s bash"
SHELLCHECKED_FILES := ".aliases .functions .git-helpers .k8s-helpers git/hooks/* .wayinit"
CONFIG_HOME := if os() == "macos" { "~/Library/Application\\ Support" } else { "~/.config" }
FONT_DIR := if os() == "macos" { "~/Library/Fonts/" } else { "/usr/share/fonts/" }

[private]
default:
  @just --list --unsorted

# create symlinks pointing to this repo checkout
link: fontguard && check
  # Dot prefixed files are linked to from $HOME
  fd -g '.*' -H --max-depth 1 --type f -a -x ln -sfn {} ~/
  # Children of config are linked to from $HOME/.config
  fd --base-directory config/ --max-depth 1 --no-ignore-vcs -a -x ln -sfn {} ~/.config/
  # Children of share are linked to from platform specific {{CONFIG_HOME}}
  fd --base-directory share/ --max-depth 1 --no-ignore-vcs -a -x ln -sfn {} {{CONFIG_HOME}}/
  # OS specific links
  ln -sf $PWD/config/alacritty/{{os()}}.toml config/alacritty/os.toml
  # key specific overrides
  lq -i '.SKIP_HOST_UPDATE=true' {{CONFIG_HOME}}/discord/settings.json

# font guard helper
fontguard:
  fd . {{FONT_DIR}} -e ttf | rg -q "Inconsolata.*Mono"
  fd . {{FONT_DIR}} -e ttf | rg -q "Liberation" # font-liberation pkg technically not necessary on mac

# reload configs insofar as possible/necessary
check:
  bat cache --build | rg -v "okay"
  zellij setup --check > /dev/null

# run local shellcheck lint
lint:
  SHELLCHECK_OPTS="{{SHELLCHECK_OPTS}}" shellcheck {{SHELLCHECKED_FILES}}

# run shellcheck lint via docker
lint-docker:
  docker run \
    -e SHELLCHECK_OPTS="{{SHELLCHECK_OPTS}}" \
    -v $PWD:/volume -w /volume \
    -t koalaman/shellcheck:stable \
    shellcheck {{SHELLCHECKED_FILES}}

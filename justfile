# See https://just.systems/man/
SHELLCHECK_OPTS := "-e SC1091 -e SC1090 -e SC1117 -s bash"
SHELLCHECKED_FILES := ".aliases .exports .bashrc .bash_completion .bash_profile .path .prompt .functions .xprofile .git-helpers .k8s-helpers .templates/git/hooks/*"

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
  echo "Linking {subdirs} that don't respect .config"
  ln -sfn $PWD/.hammerspoon ~/
  echo "Refresh"
  just reload-configs

# reload configs and themes in tools that have a command for it
reload-configs:
  touch ~/.bash_completion
  bat cache --build
  zellij setup --check

# configure code editors
editors: directories
  echo "configuring editors"
  just vscode

# install vs code plugins
vscode:
  #!/bin/bash
  declare -a exts=(
    4ops.terraform
    ban.spellright
    bierner.markdown-footnotes
    eamodio.gitlens
    esbenp.prettier-vscode
    foam.foam-vscode
    miqh.vscode-language-rust
    mushan.vscode-paste-image
    redhat.vscode-yaml
    rust-lang.rust-analyzer
    skellock.just
    tchayen.markdown-links
    yzhang.markdown-all-in-one
  )
  declare -a themes=(
    arcticicestudio.nord-visual-studio-code
    Catppuccin.catppuccin-vsc
    johnpapa.winteriscoming
    tnaseem.theme-seti
  )
  for ext in "${exts[@]}"; do
    code --install-extension $ext
  done

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
  SHELLCHECK_OPTS="{{SHELLCHECK_OPTS}}" shellcheck {{SHELLCHECKED_FILES}}

# run shellcheck lint via docker
lint-docker:
  docker run \
    -e SHELLCHECK_OPTS="{{SHELLCHECK_OPTS}}" \
    -v $$PWD:/volume -w /volume \
    -t koalaman/shellcheck:stable \
    shellcheck {{SHELLCHECKED_FILES}}

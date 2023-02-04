# See https://just.systems/man/
SHELLCHECK_OPTS := "-e SC1091 -e SC1090 -e SC1117 -s bash"
SHELLCHECKED_FILES := ".aliases .exports .bashrc .bash_completion .bash_profile .path .prompt .functions .xprofile .git-helpers .k8s-helpers .templates/git/hooks/*"

default:
  @just --list --unsorted --color=always | rg -v "    default"

# create all home subdirectories before symlinking into them
directories:
  mkdir -p ~/.config/{autostart,helix,sublime-text-3/{Local,Packages}}
  mkdir -p ~/.templates/git/hooks
  mkdir -p ~/Music

# create directories and create symlinks pointing to this repo checkout
config: directories
  #!/bin/bash
  echo "linking configs in $HOME"
  find "$PWD" -maxdepth 1 -name ".*" -type f -print -exec ln -sfn {} ~/ \;
  echo "Linking config subdirectories of $HOME"
  for d in {.config{,/helix,/alacritty,/karabiner},.templates/git/hooks}; do\
    echo $d
    find "$PWD/$d" -maxdepth 1 -type f -print -exec ln -sfn {} ~/$d \;
  done
  ln -sfn $PWD/.config/zellij ~/.config/
  touch ~/.bash_completion

# configure code editors
editors: directories
  echo "configuring sublime and installing vs code plugins"
  @[ -d ~/.config/sublime-text-3/Packages/User ] || make sublime_user
  @[ -f ~/.config/sublime-text-3/Local/License.sublime_license ] || make sublime_license
  just vscode

# link sublime 3 license
sublime_license:
  pass sublime > ~/.config/sublime-text-3/Local/License.sublime_license
# link sublime 3 user config
sublime_user:
  ln -s "$PWD/.config/sublime-text-3/Packages/User" ~/.config/sublime-text-3/Packages/User  

# install vs code plugins
vscode:
  #!/bin/bash
  declare -a exts=(
    4ops.terraform
    ban.spellright
    eamodio.gitlens
    esbenp.prettier-vscode
    foam.foam-vscode
    johnpapa.winteriscoming
    kokakiwi.vscode-just
    matklad.rust-analyzer
    miqh.vscode-language-rust
    ms-kubernetes-tools.vscode-kubernetes-tools
    mushan.vscode-paste-image
    NeelyInnovations.note-macros
    philipbe.theme-gray-matter
    redhat.vscode-yaml
    skellock.just
    tchayen.markdown-links
    tnaseem.theme-seti
    yzhang.markdown-all-in-one
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

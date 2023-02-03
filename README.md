# dotfiles

[![ci status](https://github.com/clux/dotfiles/actions/workflows/lint.yml/badge.svg)](https://github.com/clux/dotfiles/actions/workflows/lint.yml)

Personal dotfiles, and configuration for [provisioned setup](https://github.com/clux/provision).
Designed for a minimal Arch Linux installation, but retrofitted to support MacOS under duress.

## Core Configs

- **Linux**: [cinnamon](https://wiki.archlinux.org/index.php/cinnamon) running [guake](https://wiki.archlinux.org/index.php/Guake) configured by `.dconf` files
- **Mac**: mostly manual ui configuration, except alacritty / [karabiner](https://karabiner-elements.pqrs.org/docs/)

Works everywhere:

- [keychain](https://wiki.archlinux.org/index.php/SSH_keys#Keychain) loading specific ssh keys [by host](https://github.com/clux/dotfiles/blob/658ffb136167730ba272b03fd57c2be4a0bd2cc9/.bash_profile#L10-L16)
- [zoxide](https://github.com/ajeetdsouza/zoxide) for directory jumping
- [alacritty](https://github.com/alacritty/alacritty/) using zellij
- customized [shell prompt](https://github.com/clux/dotfiles/blob/master/.prompt) heavily inspired by powerline (with [starship variant](https://github.com/clux/dotfiles/issues/32))
- color themes from [vivid](https://github.com/sharkdp/vivid)
- [gitconfig](https://github.com/clux/dotfiles/blob/master/.gitconfig) with [fzf](https://github.com/junegunn/fzf) based [githelpers](https://github.com/clux/dotfiles/blob/master/.githelpers), diff via [delta](https://github.com/dandavison/delta), and account switching by `includeIf` dirs
- [aliases](https://github.com/clux/dotfiles/blob/master/.aliases) to gracefully move from `ls`->`exa`, `ag`->`rg`, `cat`->`bat`, plus a bunch of `git`, `kubectl` shortcuts

Lots of misc [.functions](https://github.com/clux/dotfiles/blob/master/.functions). As usual, copy what you find interesting.

## Usage
Clone and install:

```sh
just config
just ui # linux
```

The first symlinks all files herein to `$HOME` so they can be tracked, and updates editor configs. The second updates UI through `dconf`.

## Editors
There are helpers that install and configures a bunch of code editors non-interactively (except for potential password prompts for licenses).

### VS Code
Does not use the builtin sync.
Installs plugins based on a hardcoded list (populated via `code --list-extensions` periodically).
User config is not synced atm due to cross-platform concerns (and lack of significant default deviation).

### Helix
Easy terminal `EDITOR` with tiny [config](https://github.com/clux/dotfiles/blob/master/.config/helix/config.toml). Replacement for the modal `vim` style of editor I never got into.

### Sublime
Provisions the license from [pass](https://www.passwordstore.org/) and then links in the user package. You should run `just config` first, but if `subl` is opened before configuring it, purge the user directory first.
Generally replaced by VS Code now.

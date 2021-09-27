# dotfiles
[![ci status](https://github.com/clux/probes/actions/workflows/lint.yml/badge.svg)](https://github.com/clux/probes/actions/workflows/lint.yml)

Configuration files for packages from [provisioning scripts](https://github.com/clux/provision).

## Core Configs

- [cinnamon](https://wiki.archlinux.org/index.php/cinnamon) running [guake](https://wiki.archlinux.org/index.php/Guake) configured by `.dconf` files
- [keychain](https://wiki.archlinux.org/index.php/SSH_keys#Keychain) loading specific ssh keys [by host](https://github.com/clux/dotfiles/blob/658ffb136167730ba272b03fd57c2be4a0bd2cc9/.bash_profile#L10-L16)
- [zoxide](https://github.com/ajeetdsouza/zoxide) for directory jumping
- [mpd](https://wiki.archlinux.org/index.php/Music_Player_Daemon) service with interface on media keys or [ncmpcpp](https://wiki.archlinux.org/index.php/Ncmpcpp)
- customized [shell prompt](https://github.com/clux/dotfiles/blob/master/.prompt) heavily inspired by powerline (with [starship variant](https://github.com/clux/dotfiles/issues/32))
- color themes from [vivid](https://github.com/sharkdp/vivid)
- elaborate [gitconfig](https://github.com/clux/dotfiles/blob/master/.gitconfig) with [fzf](https://github.com/junegunn/fzf) based [githelpers](https://github.com/clux/dotfiles/blob/master/.githelpers) and diff setup for [delta](https://github.com/dandavison/delta)
- [alias](https://github.com/clux/dotfiles/blob/master/.aliases) replacements to gracefully move from `ls`->`exa`, `ag`->`rg`, `cat`->`bat`

Plus a bunch of other small stuff. As usual, copy what you find interesting.

## Usage
Clone and install:

```sh
make config
make ui
```

The first symlinks all files herein to `$HOME` so they can be tracked, and updates editor configs. The second updates UI through `dconf`.

## Sublime Note
It is fine to `make config` before sublime is installed. If it is installed, and `subl` is opened, purge the user directory.

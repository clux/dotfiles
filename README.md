# dotfiles
[![build status](https://secure.travis-ci.org/clux/dotfiles.svg)](http://travis-ci.org/clux/dotfiles)

All custom configuration files for packages installed via my [provisioning scripts](https://github.com/clux/provision).

## Features

- [bash prompt](https://github.com/clux/dotfiles/blob/master/.prompt) with customized `git` support
- [tmux](https://wiki.archlinux.org/index.php/tmux) inside [guake](https://wiki.archlinux.org/index.php/Guake) inside [cinnamon](https://wiki.archlinux.org/index.php/cinnamon)
- [URxvt](https://wiki.archlinux.org/index.php/rxvt-unicode) for persistent [TUIs](https://en.wikipedia.org/wiki/Text-based_user_interface)
- [keychain](https://wiki.archlinux.org/index.php/SSH_keys#Keychain) loading specific ssh keys [depending on hostname](https://github.com/clux/dotfiles/blob/658ffb136167730ba272b03fd57c2be4a0bd2cc9/.bash_profile#L10-L16)
- [rupa/z](https://github.com/rupa/z) for directory jumping
- [mpd](https://wiki.archlinux.org/index.php/Music_Player_Daemon) service with interface on media keys or [ncmpcpp](https://wiki.archlinux.org/index.php/Ncmpcpp)

Plus a bunch of other small stuff. As usual, copy what you find interesting.

## Usage
Clone and install:

```sh
make config
make ui
```

The first symlinks all files herein to `$HOME` so they can be tracked. The second updates UI through `dconf` and `gconf`.

## Sublime Note
It is fine to `make config` before sublime is installed. If it is installed, and `subl` is opened, purge the user directory.

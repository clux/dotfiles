# dotfiles
[![build status](https://secure.travis-ci.org/clux/dotfiles.svg)](http://travis-ci.org/clux/dotfiles)

Separated from installation scripts because these are mostly install agnostic, and changes do not deserve full OS rebuilds to test.

## Usage
Clone and install:

```sh
make config
make ui
```

The first symlinks all files herein to `$HOME` so they can be tracked. The second updates UI through dconf and gconf.

## Manual configuration steps
Some stuff is still manually configured, but the remaining stuff is all setup in such a way that they can be done while the standard [installation scripts](https://github.com/clux/dotclux) are going.

### UX
Mostly locked down at this point, but probably still need to:

- look and feel of UI
- remove unnecessary startup apps

Could add whatever we find necessary to the script next time.

### Configure sublime

- [license](https://mail.google.com/mail/u/0/#search/sublime+license/13a942d72a211e81)
- [package control](https://packagecontrol.io/installation)

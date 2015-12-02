# dotfiles
[![build status](https://secure.travis-ci.org/clux/dotfiles.svg)](http://travis-ci.org/clux/dotfiles)

Separated from [installation scripts](https://github.com/clux/dotclux) because these are mostly install agnostic, and changes do not deserve full OS rebuilds to test. Packages may be necessary to replicate behaviour, but nothing you can't figure out from above repo.

## Usage
Clone and install:

```sh
make config
make ui
sudo make etc
```

The first symlinks all files herein to `$HOME` so they can be tracked. The second updates UI through dconf and gconf.

## Sublime
Because sublime-text is annoyingly manual in some areas:

- [license](https://mail.google.com/mail/u/0/#search/sublime+license/13a942d72a211e81)
- [package control](https://packagecontrol.io/installation)

Should be fine to `make config`, before or install as long as it's done before `subl` is opened.

# dotfiles
[![build status](https://secure.travis-ci.org/clux/dotfiles.svg)](http://travis-ci.org/clux/dotfiles)

Separated from installation scripts because these are mostly install agnostic, and changes do not deserve full OS rebuilds to test.

## Usage
Clone and run `./install.sh`. This symlinks all files herein to `$HOME` so they can be tracked.

## Manual configuration steps
Some stuff is still manually configured, but the remaining stuff is all setup in such a way that they can be done while the standard [installation scripts](https://github.com/clux/dotclux) are going.

### UX

- keyboard layout: add "us int dead", alt-shift change, caps compose
- look and feel of UI:
  * effects: OFF
  * mouse: pad on, no clicks on pad, two finger basic
- remove unnecessary startup apps
- configure guake (untick all checkboxes, 60% height, 4k buffer, 20% transparency, shortcuts)

### Configure sublime

- [license](https://mail.google.com/mail/u/0/#search/sublime+license/13a942d72a211e81)
- [package control](https://packagecontrol.io/installation)

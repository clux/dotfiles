# dotfiles

[![ci status](https://github.com/clux/dotfiles/actions/workflows/lint.yml/badge.svg)](https://github.com/clux/dotfiles/actions/workflows/lint.yml)

Personal dotfiles, and configuration for [provisioned setup](https://github.com/clux/provision).
Designed for a minimal Arch Linux installation, but retrofitted to support MacOS under duress.

## Desktop Setup

- **Linux**: [cinnamon](https://wiki.archlinux.org/index.php/cinnamon) + [guake](https://wiki.archlinux.org/index.php/Guake) via `dconf`
- **Mac**: [defaults](https://github.com/clux/dotfiles/blob/main/defaults.sh) with [hammerspoon](https://github.com/Hammerspoon/hammerspoon) + [karabiner](https://karabiner-elements.pqrs.org/docs/)

## Terminal Setup

- [zellij](https://zellij.dev/) in [alacritty](https://github.com/alacritty/alacritty/)
- [zoxide](https://github.com/ajeetdsouza/zoxide) for directory jumping
- [powerline](https://github.com/b-ryan/powerline-shell) style [custom bash prompt](https://github.com/clux/dotfiles/blob/main/.prompt) / [starship variant](https://github.com/clux/dotfiles/blob/main/config/starship.toml) (needs nerd fonts / powerline fonts)
- [terminal styling](https://hachyderm.io/@clux/109815971667731738) through: [alacritty](https://github.com/alacritty/alacritty-theme#color-schemes) / [vivid](https://github.com/sharkdp/vivid/tree/master/themes) / [bat](https://github.com/sharkdp/bat/tree/master/assets/themes)[*](https://github.com/catppuccin/bat) / [hx](https://github.com/helix-editor/helix/tree/master/runtime/themes) / [zellij](https://github.com/zellij-org/zellij/tree/main/example/themes) / [delta](https://dandavison.github.io/delta/supported-languages-and-themes.html#supported-languages-and-themes)[*](https://dandavison.github.io/delta/custom-themes.html?highlight=theme#custom-themes) / [starship](https://starship.rs/advanced-config/#style-strings) / [ripgrep](https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md#configuration-file) / [fzf](https://github.com/catppuccin/fzf) -> see [invocations](https://github.com/clux/dotfiles/search?o=desc&q=theme&s=indexed)
- [kubernetes helpers](https://github.com/clux/dotfiles/blob/main/.k8s-helpers) with abbrev aliases, ns/ctx switchers, interactive lookup fns using `fzf`
- [gitconfig](https://github.com/clux/dotfiles/blob/main/.gitconfig) with [fzf](https://github.com/junegunn/fzf) based [git helpers](https://github.com/clux/dotfiles/blob/main/.git-helpers), diff via [delta](https://github.com/dandavison/delta), and account switching by `includeIf` dirs
- [keychain](https://wiki.archlinux.org/index.php/SSH_keys#Keychain) loading specific ssh keys [by host](https://github.com/clux/dotfiles/blob/658ffb136167730ba272b03fd57c2be4a0bd2cc9/.bash_profile#L10-L16)
- [aliases](https://github.com/clux/dotfiles/blob/main/.aliases) to gracefully move from `ls`->`exa`, `ag`->`rg`, `cat`->`bat`

Plus lots of misc [.functions](https://github.com/clux/dotfiles/blob/main/.functions). As usual, copy what you find interesting.

## Usage
Clone and apply:

```sh
just config # force symlink to ~/ and ~/.config/
just system # defaults write (mac) / dconf load (linux)
```

All recipes are idempotent.

## Editors

### VS Code
System configuration includes `vscode` recipe to symlink [settings.json](https://github.com/clux/dotfiles/blob/main/vscode/settings.json) and install a [snapshot of extensions](https://github.com/clux/dotfiles/blob/main/vscode/extensions) and themes via `code --list-extensions`. This avoids the builtin cloud sync.

### Helix
Automatic install via `just config` relying on `EDITOR`. Tiny [config](https://github.com/clux/dotfiles/blob/main/config/helix/config.toml) always linked.

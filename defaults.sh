#!/bin/env bash
set -euo pipefail

if [[ ! "${OSTYPE}" =~ "darwin" ]]; then
  echo "MAC ONLY"
  exit 1
fi

###############################################################################
# Apps                                                                      #
###############################################################################

# put hammerspoon config dir under ~/.config
defaults write org.hammerspoon.Hammerspoon MJConfigFile ~/.config/hammerspoon/init.lua

###############################################################################
# Screen                                                                      #
###############################################################################

# Save screenshots to ~/Pictures
defaults write com.apple.screencapture location -string "${HOME}/Pictures"

###############################################################################
# Finder                                                                      #
###############################################################################

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# default finder dir is ~
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# open in new windows rather than tabs
defaults write com.apple.finder FinderSpawnTab -float 0

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Do not group list view
defaults write com.apple.finder FXPreferredGroupBy -string "None"

# Show hidden files
defaults write com.apple.finder "AppleShowAllFiles" -bool "true"

# Show the ~/Library folder
chflags nohidden ~/Library

#!/bin/env bash
set -euo pipefail

if [[ ! "${OSTYPE}" =~ "darwin" ]]; then
  echo "MAC ONLY"
  exit 1
fi

osascript -e 'tell application "System Preferences" to quit'

###############################################################################
# Dock                                                                        #
###############################################################################

# disable hot corners
defaults write com.apple.dock wvous-bl-corner -int 1
defaults write com.apple.dock wvous-br-corner -int 1
defaults write com.apple.dock wvous-tl-corner -int 1
defaults write com.apple.dock wvous-tr-corner -int 1

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0
# Remove the animation when hiding/showing the Dock
defaults write com.apple.dock autohide-time-modifier -float 0

# less offensive minimisation effect than genie
defaults write com.apple.dock mineffect -string "scale"

# don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# don’t show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

# show only open applications in the Dock
defaults write com.apple.dock static-only -bool true

###############################################################################
# locale                                                                      #
###############################################################################

defaults write NSGlobalDomain AppleLanguages -array "en-GB"
defaults write NSGlobalDomain AppleLocale -string "en_GB"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true

###############################################################################
# Apps                                                                       #
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

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Do not group list view
defaults write com.apple.finder FXPreferredGroupBy -string "None"

# Show hidden files
defaults write com.apple.finder "AppleShowAllFiles" -bool "true"

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Show the ~/Library folder
chflags nohidden ~/Library

###############################################################################

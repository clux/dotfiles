#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

# Ensure directory trees exist
mkdir -p ~/.config/sublime-text-3/Packages
mkdir -p ~/.config/autostart
mkdir -p ~/.templates/npm

echo "Symlinking .files to ~/"
find "$PWD" -name ".*" -not -name ".gitignore" -type f -print -exec ln -sfn {} ~/ \;
echo "Symlinking files in .config to ~/.config"
find "$PWD/.config" -maxdepth 1 -type f -print -exec ln -sfn {} ~/.config \;

echo "Symlinking files in .templates to ~/.templates"
find "$PWD/.templates/npm" -maxdepth 1 -type f -print -exec ln -sfn {} ~/.templates/npm \;

# Do the annoying stuff first
echo "Symlinking User package in sublime-text-3"
ln -sf "$PWD/.config/sublime-text-3/Packages/User" ~/.config/sublime-text-3/Packages/User

echo "Symlinking files in .config/autostart to ~/.config/autostart"
find "$PWD/.config/autostart" -maxdepth 1 -type f -print -exec ln -sfn {} ~/.config/autostart \;

#!/bin/bash
set -euo pipefail

cd $(dirname $0)

echo "Symlinking .files to ~/"
find $PWD -name ".*" -not -name ".gitignore" -type f -print -exec ln -sfn {} ~/ \;
echo "Symlinking files in .config to ~/.config"
find $PWD/.config -maxdepth 1 -type f -print -exec ln -sfn {} ~/.config \;

# symlink remaining folders that do not match normal patterns
mkdir -p ~/.config/sublime-text-3/Packages/
echo "ln -sf ~/.config/sublime-text-3/Packages/User/ ~/.config/sublime-text-3/Packages/User"
# copy static stuff
cp .config/autostart/* ~/.config/autostart

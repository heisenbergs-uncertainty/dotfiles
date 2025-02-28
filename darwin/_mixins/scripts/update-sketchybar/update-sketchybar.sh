#!/usr/bin/env bash

echo "Instaling/Updating Sketchybar"

brew tap FelixKratz/formulae
brew install sketchybar

# Fetch sketchybar configuration
echo "Fetching Sketchybar app font"
curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.28/sketchybar-app-font.ttf -o $HOME/Library/Fonts/sketchybar-app-font.ttf

# SbarLua
echo "Clonning Updates SbarLua package"
(git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua && cd /tmp/SbarLua/ && make install && rm -rf /tmp/SbarLua/)

echo "Cloning Config from FelixKratz dotfiles"
git clone https://github.com/FelixKratz/dotfiles.git /tmp/dotfiles
mv "$HOME/.config/sketchybar" "$HOME/.config/sketchybar_backup"
mv /tmp/dotfiles/.config/sketchybar "$HOME/.config/sketchybar"
rm -rf /tmp/dotfiles

brew services start sketchybar

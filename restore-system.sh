#!/bin/bash

# Install native packages
sudo pacman -S --needed - < pkglist.txt

# Install AUR packages (requires AUR helper like yay or paru)
yay -S --needed - < pkglist-aur.txt

# Symlink configs (example)
ln -sf ~/.dotfiles/omarchy ~/.config/omarchy
ln -sf ~/.dotfiles/nvim ~/.config/nvim
# ... other symlinks

echo "System restored!"

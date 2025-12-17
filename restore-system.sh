#!/bin/bash

set -e  # Exit on error

echo "📦 Installing packages..."

# Install native packages
sudo pacman -S --needed - < pkglist.txt

# Install AUR packages (requires AUR helper like yay or paru)
yay -S --needed - < pkglist-aur.txt

echo ""
echo "🔗 Installing GNU Stow (if needed)..."
sudo pacman -S --needed stow

echo ""
echo "🔗 Symlinking dotfiles with Stow..."
cd ~/personal/.dotfiles

# Stow all packages
stow */

echo ""
echo "✅ System restored!"

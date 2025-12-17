#!/bin/bash

set -e  # Exit on error for package installation

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

# Temporarily disable exit on error for stow operations
set +e

# Unstow all packages first to clean up (may fail if not stowed, that's OK)
echo "  Cleaning up existing symlinks..."
stow -D -t "$HOME" */ 2>/dev/null || true

# Handle special cases where directories exist with other files
# (like ~/.config/hypr which has files not in dotfiles)
echo "  Resolving conflicts..."
# Remove individual file symlinks in hypr that might conflict
rm -f ~/.config/hypr/{bindings.conf,looknfeel.conf,rules.conf} 2>/dev/null || true

# Remove any old symlinks pointing to wrong locations
# Check for symlinks pointing to old config/ structure or wrong package names
for target in nvim omarchy; do
    if [ -L ~/.config/"$target" ]; then
        link_target=$(readlink -f ~/.config/"$target" 2>/dev/null)
        # Remove if it points to old config/ structure or doesn't point to correct stow package
        if echo "$link_target" | grep -q "\.dotfiles.*config/" || \
           ! echo "$link_target" | grep -q "\.dotfiles.*${target}-stow\|\.dotfiles/${target}/"; then
            rm -f ~/.config/"$target"
        fi
    fi
done

# Stow all packages with explicit target
echo "  Creating symlinks..."
stow -t "$HOME" */

# Re-enable exit on error
set -e
echo ""
echo "🔄 Reloading configurations..."
sleep 5

# Reload Hyprland
echo "  Reloading Hyprland..."
hyprctl reload 2>/dev/null || true

# Reload tmux config
echo "  Reloading tmux config..."
tmux source-file ~/.tmux.conf 2>/dev/null || true

# Starship auto-reloads on next prompt
echo "  Starship will auto-reload on next prompt"

# Reload waybar
echo "  Reloading waybar..."
pkill -SIGUSR2 waybar 2>/dev/null || true

# Reload mako (notification daemon)
echo "  Reloading mako..."
makoctl reload 2>/dev/null || true

# Reload zshrc (for current shell if running zsh)
if [ -n "$ZSH_VERSION" ] || [ "$SHELL" = "/usr/bin/zsh" ] || [ "$SHELL" = "/bin/zsh" ]; then
    echo "  Reloading .zshrc in current shell..."
    source ~/.zshrc 2>/dev/null || true
else
    echo "  .zshrc will be loaded in new zsh sessions"
fi

echo ""
echo "✅ System restored and configurations reloaded!"

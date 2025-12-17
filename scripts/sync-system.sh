#!/bin/bash

set -e  # Exit on error for package installation

echo "📦 Managing packages..."

# Check for packages to remove (installed but not in list)
echo "  Checking for packages to remove..."
cd ~/personal/.dotfiles

# Get list of packages that are installed but not in pkglist.txt
if [ -f pkglist.txt ]; then
    packages_to_remove=$(comm -23 <(pacman -Qqen | sort) <(sort pkglist.txt) 2>/dev/null || true)
    if [ -n "$packages_to_remove" ]; then
        echo ""
        echo "  ⚠️  The following native packages are installed but not in pkglist.txt:"
        echo "$packages_to_remove" | head -20
        [ $(echo "$packages_to_remove" | wc -l) -gt 20 ] && echo "  ... and $(($(echo "$packages_to_remove" | wc -l) - 20)) more"
        echo ""
        # Only ask interactively if we have a TTY
        if [ -t 0 ]; then
            read -p "  Remove these packages? (y/N) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                should_remove=true
            else
                should_remove=false
            fi
        else
            echo "  Skipping removal (non-interactive mode)"
            should_remove=false
        fi
        
        if [ "$should_remove" = true ]; then
            echo "  Removing packages..."
            # Exclude base packages and important system packages
            exclude_packages="base base-devel linux linux-firmware linux-headers"
            for pkg in $packages_to_remove; do
                # Skip if it's a base package or dependency
                if ! echo "$exclude_packages" | grep -q "$pkg"; then
                    sudo pacman -Rns "$pkg" --noconfirm 2>/dev/null || true
                fi
            done
        else
            echo "  Skipping package removal"
        fi
    fi
fi

# Check for AUR packages to remove
if [ -f pkglist-aur.txt ]; then
    aur_to_remove=$(comm -23 <(pacman -Qqem | sort) <(sort pkglist-aur.txt) 2>/dev/null || true)
    if [ -n "$aur_to_remove" ]; then
        echo ""
        echo "  ⚠️  The following AUR packages are installed but not in pkglist-aur.txt:"
        echo "$aur_to_remove" | head -20
        [ $(echo "$aur_to_remove" | wc -l) -gt 20 ] && echo "  ... and $(($(echo "$aur_to_remove" | wc -l) - 20)) more"
        echo ""
        # Only ask interactively if we have a TTY
        if [ -t 0 ]; then
            read -p "  Remove these AUR packages? (y/N) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                should_remove_aur=true
            else
                should_remove_aur=false
            fi
        else
            echo "  Skipping AUR removal (non-interactive mode)"
            should_remove_aur=false
        fi
        
        if [ "$should_remove_aur" = true ]; then
            echo "  Removing AUR packages..."
            for pkg in $aur_to_remove; do
                yay -Rns "$pkg" --noconfirm 2>/dev/null || true
            done
        else
            echo "  Skipping AUR package removal"
        fi
    fi
fi

echo ""
echo "  Installing/updating packages..."

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

# Function to check if a package is correctly stowed
check_stow_package() {
    local pkg=$1
    local pkg_dir="$HOME/personal/.dotfiles/$pkg"
    
    # Check if package directory exists
    [ ! -d "$pkg_dir" ] && return 1
    
    # Use stow dry-run to check if it would create any links
    # If it would create links, the package is not stowed
    # stow -n outputs "LINK:" for each symlink it would create
    local stow_output
    stow_output=$(stow -n -t "$HOME" "$pkg" 2>&1)
    
    # If output contains "LINK:", package needs stowing
    if echo "$stow_output" | grep -q "LINK:"; then
        return 1  # Not stowed or incorrect
    fi
    
    # Also check for conflict warnings (means something is wrong)
    if echo "$stow_output" | grep -qi "conflict\|existing target"; then
        return 1  # Has conflicts, needs fixing
    fi
    
    return 0  # Correctly stowed
}

# Check which packages need to be stowed
packages_to_stow=()
for pkg in */; do
    pkg_name=$(basename "$pkg")
    if ! check_stow_package "$pkg_name"; then
        packages_to_stow+=("$pkg_name")
    fi
done

if [ ${#packages_to_stow[@]} -eq 0 ]; then
    echo "  ✓ All packages are already correctly stowed"
    # Set empty array so we know nothing was stowed
    stowed_packages=()
else
    echo "  Packages to stow: ${packages_to_stow[*]}"
    
    # Unstow packages that need updating
    echo "  Cleaning up existing symlinks..."
    for pkg in "${packages_to_stow[@]}"; do
        stow -D -t "$HOME" "$pkg" 2>/dev/null || true
    done
    
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
    
    # Stow packages that need updating
    echo "  Creating symlinks..."
    for pkg in "${packages_to_stow[@]}"; do
        stow -t "$HOME" "$pkg"
    done
    
    # Store which packages were stowed for reload
    stowed_packages=("${packages_to_stow[@]}")
fi

# Re-enable exit on error
set -e

# Only reload if packages were actually stowed
if [ ${#stowed_packages[@]} -gt 0 ]; then
    echo ""
    echo "🔄 Reloading configurations for updated packages..."
    sleep 5
    
    # Check which services need reloading based on stowed packages
    needs_hypr_reload=false
    needs_tmux_reload=false
    needs_zsh_reload=false
    needs_waybar_reload=false
    needs_mako_reload=false
    
    for pkg in "${stowed_packages[@]}"; do
        case "$pkg" in
            hypr)
                needs_hypr_reload=true
                ;;
            tmux)
                needs_tmux_reload=true
                ;;
            zsh)
                needs_zsh_reload=true
                ;;
            waybar|omarchy-stow)
                needs_waybar_reload=true
                ;;
            mako|omarchy-stow)
                needs_mako_reload=true
                ;;
        esac
    done
    
    # Reload Hyprland if hypr package was stowed
    if [ "$needs_hypr_reload" = true ]; then
        echo "  Reloading Hyprland..."
        hyprctl reload 2>/dev/null || true
    fi
    
    # Reload tmux config if tmux package was stowed
    if [ "$needs_tmux_reload" = true ]; then
        echo "  Reloading tmux config..."
        tmux source-file ~/.tmux.conf 2>/dev/null || true
    fi
    
    # Reload waybar if waybar/omarchy was stowed
    if [ "$needs_waybar_reload" = true ]; then
        echo "  Reloading waybar..."
        pkill -SIGUSR2 waybar 2>/dev/null || true
    fi
    
    # Reload mako if mako/omarchy was stowed
    if [ "$needs_mako_reload" = true ]; then
        echo "  Reloading mako..."
        makoctl reload 2>/dev/null || true
    fi
    
    # Reload zshrc if zsh package was stowed
    if [ "$needs_zsh_reload" = true ]; then
        if [ -n "$ZSH_VERSION" ] || [ "$SHELL" = "/usr/bin/zsh" ] || [ "$SHELL" = "/bin/zsh" ]; then
            echo "  Reloading .zshrc in current shell..."
            source ~/.zshrc 2>/dev/null || true
        else
            echo "  .zshrc will be loaded in new zsh sessions"
        fi
    fi
    
    # Starship auto-reloads on next prompt (always mention if starship was stowed)
    if printf '%s\n' "${stowed_packages[@]}" | grep -q "starship"; then
        echo "  Starship will auto-reload on next prompt"
    fi
else
    echo ""
    echo "  ✓ No packages were stowed, skipping reloads"
fi

echo ""
echo "✅ System restored and configurations reloaded!"
echo ""
# Wait for user to press q to exit (useful for popups)
if [ -t 0 ]; then
    while true; do
        read -n 1 -s -p "Press 'q' to exit... " key
        echo
        [ "$key" = "q" ] && break || true
    done
fi

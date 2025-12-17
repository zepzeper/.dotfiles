#!/bin/bash

set -e  # Exit on error for package installation

# Detect architecture
ARCH=$(uname -m)
if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
    echo "🐧 Detected: Linux ARM64 (aarch64)"
elif [ "$ARCH" = "x86_64" ]; then
    echo "🐧 Detected: Linux x86_64"
else
    echo "🐧 Detected: Linux ($ARCH)"
fi

echo "📦 Managing packages..."

# Check for packages to remove (installed but not in list)
echo "  Checking for packages to remove..."
cd ~/personal/.dotfiles

# Determine which package list to use for comparison
if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
    COMPARE_PKGLIST="pkglist-aarch64.txt"
    FALLBACK_COMPARE="pkglist.txt"
else
    COMPARE_PKGLIST="pkglist-x86_64.txt"
    FALLBACK_COMPARE="pkglist.txt"
fi

# Get list of packages that are installed but not in package list
# Combine architecture-specific and shared lists for comparison
PKGLIST_TO_USE=""
if [ -f "$COMPARE_PKGLIST" ] && [ -f "$FALLBACK_COMPARE" ]; then
    # Merge both lists for comparison
    PKGLIST_TO_USE="/tmp/pkglist-merged.txt"
    (cat "$FALLBACK_COMPARE" "$COMPARE_PKGLIST" | sort -u) > "$PKGLIST_TO_USE"
elif [ -f "$COMPARE_PKGLIST" ]; then
    PKGLIST_TO_USE="$COMPARE_PKGLIST"
elif [ -f "$FALLBACK_COMPARE" ]; then
    PKGLIST_TO_USE="$FALLBACK_COMPARE"
fi

if [ -n "$PKGLIST_TO_USE" ]; then
    packages_to_remove=$(comm -23 <(pacman -Qqen | sort) <(sort "$PKGLIST_TO_USE") 2>/dev/null || true)
    # Clean up merged temp file if we created one
    if [ "$PKGLIST_TO_USE" = "/tmp/pkglist-merged.txt" ]; then
        rm -f "$PKGLIST_TO_USE"
    fi
    if [ -n "$packages_to_remove" ]; then
        echo ""
        echo "  ⚠️  The following native packages are installed but not in $PKGLIST_TO_USE:"
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
if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
    COMPARE_AUR="pkglist-aur-aarch64.txt"
    FALLBACK_AUR="pkglist-aur.txt"
else
    COMPARE_AUR="pkglist-aur-x86_64.txt"
    FALLBACK_AUR="pkglist-aur.txt"
fi

AUR_TO_USE=""
if [ -f "$COMPARE_AUR" ] && [ -f "$FALLBACK_AUR" ]; then
    # Merge both lists for comparison
    AUR_TO_USE="/tmp/pkglist-aur-merged.txt"
    (cat "$FALLBACK_AUR" "$COMPARE_AUR" | sort -u) > "$AUR_TO_USE"
elif [ -f "$COMPARE_AUR" ]; then
    AUR_TO_USE="$COMPARE_AUR"
elif [ -f "$FALLBACK_AUR" ]; then
    AUR_TO_USE="$FALLBACK_AUR"
fi

if [ -n "$AUR_TO_USE" ]; then
    aur_to_remove=$(comm -23 <(pacman -Qqem | sort) <(sort "$AUR_TO_USE") 2>/dev/null || true)
    # Clean up merged temp file if we created one
    if [ "$AUR_TO_USE" = "/tmp/pkglist-aur-merged.txt" ]; then
        rm -f "$AUR_TO_USE"
    fi
    if [ -n "$aur_to_remove" ]; then
        echo ""
        echo "  ⚠️  The following AUR packages are installed but not in $AUR_TO_USE:"
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

# Sync pacman database first
echo "  Syncing package database..."
sudo pacman -Sy

# Determine which package lists to use based on architecture
if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
    PKGLIST="pkglist-aarch64.txt"
    PKGLIST_AUR="pkglist-aur-aarch64.txt"
    FALLBACK_PKGLIST="pkglist.txt"
    FALLBACK_PKGLIST_AUR="pkglist-aur.txt"
else
    PKGLIST="pkglist-x86_64.txt"
    PKGLIST_AUR="pkglist-aur-x86_64.txt"
    FALLBACK_PKGLIST="pkglist.txt"
    FALLBACK_PKGLIST_AUR="pkglist-aur.txt"
fi

# Install native packages
# Combine architecture-specific and shared lists if both exist
if [ -f "$PKGLIST" ] && [ -f "$FALLBACK_PKGLIST" ]; then
    echo "  Installing native packages ($PKGLIST + $FALLBACK_PKGLIST)..."
    # Merge both lists, remove duplicates
    (cat "$FALLBACK_PKGLIST" "$PKGLIST" | sort -u) | sudo pacman -S --needed - || true
elif [ -f "$PKGLIST" ]; then
    echo "  Installing native packages ($PKGLIST)..."
    sudo pacman -S --needed - < "$PKGLIST"
elif [ -f "$FALLBACK_PKGLIST" ]; then
    echo "  Installing native packages ($FALLBACK_PKGLIST)..."
    sudo pacman -S --needed - < "$FALLBACK_PKGLIST"
else
    echo "  ⚠️  No package list found for $ARCH"
fi

# Install AUR packages (requires AUR helper like yay or paru)
# Combine architecture-specific and shared lists if both exist
if [ -f "$PKGLIST_AUR" ] && [ -f "$FALLBACK_PKGLIST_AUR" ]; then
    echo "  Installing AUR packages ($PKGLIST_AUR + $FALLBACK_PKGLIST_AUR)..."
    # Merge both lists, remove duplicates
    (cat "$FALLBACK_PKGLIST_AUR" "$PKGLIST_AUR" | sort -u) | yay -S --needed - || true
elif [ -f "$PKGLIST_AUR" ]; then
    echo "  Installing AUR packages ($PKGLIST_AUR)..."
    yay -S --needed - < "$PKGLIST_AUR"
elif [ -f "$FALLBACK_PKGLIST_AUR" ]; then
    echo "  Installing AUR packages ($FALLBACK_PKGLIST_AUR)..."
    yay -S --needed - < "$FALLBACK_PKGLIST_AUR"
fi

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
# Skip platform-specific packages
packages_to_stow=()
for pkg in */; do
    pkg_name=$(basename "$pkg")
    
    # Skip architecture-specific packages if needed
    # For example, some packages might only work on x86_64
    if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
        # Skip x86_64-only packages on ARM
        case "$pkg_name" in
            # Add x86_64-only packages here if needed
            *)
                # Continue checking
                ;;
        esac
    elif [ "$ARCH" = "x86_64" ]; then
        # Skip ARM-only packages on x86_64 (if any)
        case "$pkg_name" in
            # Add ARM-only packages here if needed
            *)
                # Continue checking
                ;;
        esac
    fi
    
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
    
    # For packages with existing files/directories, remove them before stowing
    # This ensures clean symlink creation
    echo "  Removing existing targets that conflict with stow..."
    for pkg in "${packages_to_stow[@]}"; do
        # Check if stowing would cause conflicts
        stow_output=$(stow -n -t "$HOME" "$pkg" 2>&1)
        if echo "$stow_output" | grep -q "cannot stow.*over existing target"; then
            echo "    Handling conflicts for $pkg..."
            # Get list of conflicts from dry-run
            conflicts=$(echo "$stow_output" | grep "cannot stow.*over existing target" | sed "s/.*existing target //" | sed "s/ since.*//" | sort -u)
            for conflict in $conflicts; do
                conflict_path="$HOME/$conflict"
                # If it's a regular file (not a symlink), remove it
                if [ -f "$conflict_path" ] && [ ! -L "$conflict_path" ]; then
                    echo "      Removing conflicting file: $conflict"
                    rm -f "$conflict_path" 2>/dev/null || true
                # If it's a directory (not a symlink), remove it recursively
                # This allows stow to create the directory symlink and then symlink files inside
                elif [ -d "$conflict_path" ] && [ ! -L "$conflict_path" ]; then
                    echo "      Removing conflicting directory: $conflict"
                    rm -rf "$conflict_path" 2>/dev/null || true
                # If it's a symlink pointing to wrong location, remove it
                elif [ -L "$conflict_path" ]; then
                    link_target=$(readlink -f "$conflict_path" 2>/dev/null)
                    # Check if symlink doesn't point to our stow package
                    if ! echo "$link_target" | grep -q "\.dotfiles.*$pkg"; then
                        echo "      Removing incorrect symlink: $conflict -> $link_target"
                        rm -f "$conflict_path" 2>/dev/null || true
                    fi
                fi
            done
        fi
    done
    
    # Stow packages that need updating
    echo "  Creating symlinks..."
    for pkg in "${packages_to_stow[@]}"; do
        # Use --adopt as fallback, but filter out absolute symlink warnings (they're harmless)
        stow --adopt -t "$HOME" "$pkg" 2>&1 | grep -v "WARNING.*absolute symlink" || {
            # If adopt fails, try without adopt (conflicts should be resolved now)
            stow -t "$HOME" "$pkg" 2>&1 | grep -v "WARNING.*absolute symlink" || true
        }
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

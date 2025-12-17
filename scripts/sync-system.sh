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

# Define your stow packages explicitly
# Adjust this list to match your actual package directories
STOW_PACKAGES=(
    "hypr"
    "nvim"
    "tmux"
    "zsh"
    "waybar"
    "mako"
    "starship"
    "omarchy-stow"
)

# Function to check if a package is correctly stowed
is_stowed() {
    local pkg=$1
    local pkg_dir="$HOME/personal/.dotfiles/$pkg"
    
    # Check if package directory exists
    [ ! -d "$pkg_dir" ] && return 1
    
    # Check if at least one file from the package is correctly symlinked
    local found_correct_link=false
    while IFS= read -r -d '' file; do
        local rel_path="${file#$pkg_dir/}"
        local target_path="$HOME/$rel_path"
        
        # Check if symlink exists and points to correct location
        if [ -L "$target_path" ]; then
            local link_target="$(readlink "$target_path")"
            # Resolve to absolute path for comparison
            local link_dir="$(dirname "$target_path")"
            local resolved=""
            if [[ "$link_target" == /* ]]; then
                # Absolute path
                resolved="$link_target"
            else
                # Relative path
                resolved="$(cd "$link_dir" && cd "$(dirname "$link_target")" 2>/dev/null && pwd)/$(basename "$link_target")"
            fi
            
            if [ "$resolved" = "$file" ]; then
                found_correct_link=true
                break
            fi
        fi
    done < <(find "$pkg_dir" -type f -print0 2>/dev/null)
    
    [ "$found_correct_link" = true ] && return 0 || return 1
}

# Check which packages need stowing
packages_to_stow=()
for pkg in "${STOW_PACKAGES[@]}"; do
    if [ ! -d "$pkg" ]; then
        echo "  ⚠️  Package directory not found: $pkg (skipping)"
        continue
    fi
    
    # Skip architecture-specific packages if needed
    if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
        # Add any x86_64-only packages here to skip on ARM
        case "$pkg" in
            # example-x86-only-package)
            #     echo "  Skipping $pkg (x86_64 only)"
            #     continue
            #     ;;
            *)
                ;;
        esac
    fi
    
    if ! is_stowed "$pkg"; then
        packages_to_stow+=("$pkg")
    fi
done

if [ ${#packages_to_stow[@]} -eq 0 ]; then
    echo "  ✓ All packages are already correctly stowed"
    stowed_packages=()
else
    echo "  Packages needing stow: ${packages_to_stow[*]}"
    
    # Unstow packages first to clean up old symlinks
    echo "  Cleaning up existing symlinks..."
    for pkg in "${packages_to_stow[@]}"; do
        stow -D -t "$HOME" "$pkg" 2>/dev/null || true
    done
    
    # Check for conflicts before stowing
    echo "  Checking for conflicts..."
    packages_with_conflicts=()
    for pkg in "${packages_to_stow[@]}"; do
        # Run stow in dry-run mode to detect conflicts
        conflict_output=$(stow -n -t "$HOME" "$pkg" 2>&1)
        
        if echo "$conflict_output" | grep -q "existing target is neither"; then
            packages_with_conflicts+=("$pkg")
            echo ""
            echo "    ⚠️  Conflicts found for $pkg:"
            echo "$conflict_output" | grep "existing target" | sed 's/^/      /'
            echo ""
        fi
    done
    
    # If there are conflicts, give user options
    if [ ${#packages_with_conflicts[@]} -gt 0 ]; then
        echo "  Found conflicts in: ${packages_with_conflicts[*]}"
        echo ""
        echo "  To resolve conflicts, you can:"
        echo "    1. Manually backup/remove conflicting files"
        echo "    2. Use 'stow --adopt' to move existing files into stow package"
        echo "    3. Skip conflicting packages for now"
        echo ""
        
        if [ -t 0 ]; then
            read -p "  Continue stowing non-conflicting packages? (Y/n) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Nn]$ ]]; then
                echo "  Aborted by user"
                set -e
                exit 1
            fi
            
            # Remove conflicting packages from the stow list
            for conflict_pkg in "${packages_with_conflicts[@]}"; do
                packages_to_stow=("${packages_to_stow[@]/$conflict_pkg}")
            done
            # Remove empty elements
            packages_to_stow=("${packages_to_stow[@]}")
        else
            echo "  Skipping conflicting packages in non-interactive mode"
            for conflict_pkg in "${packages_with_conflicts[@]}"; do
                packages_to_stow=("${packages_to_stow[@]/$conflict_pkg}")
            done
            packages_to_stow=("${packages_to_stow[@]}")
        fi
    fi
    
    # Stow packages that don't have conflicts
    echo "  Creating symlinks..."
    successfully_stowed=()
    for pkg in "${packages_to_stow[@]}"; do
        # Skip empty elements
        [ -z "$pkg" ] && continue
        
        echo "    Stowing $pkg..."
        if stow -v -t "$HOME" "$pkg" 2>&1 | tee /tmp/stow-$pkg.log | grep -v "WARNING.*absolute symlink"; then
            # Check if stow actually succeeded (no errors in output)
            if ! grep -q "ERROR\|existing target" /tmp/stow-$pkg.log; then
                echo "      ✓ $pkg stowed successfully"
                successfully_stowed+=("$pkg")
            else
                echo "      ✗ Failed to stow $pkg (check /tmp/stow-$pkg.log)"
            fi
        else
            echo "      ✗ Failed to stow $pkg"
        fi
    done
    
    stowed_packages=("${successfully_stowed[@]}")
    
    # Report on conflicting packages
    if [ ${#packages_with_conflicts[@]} -gt 0 ]; then
        echo ""
        echo "  ⚠️  The following packages were skipped due to conflicts:"
        for pkg in "${packages_with_conflicts[@]}"; do
            echo "      - $pkg"
        done
        echo ""
        echo "  To manually fix conflicts, run:"
        echo "      cd ~/personal/.dotfiles"
        for pkg in "${packages_with_conflicts[@]}"; do
            echo "      stow -n -v $pkg  # Check what conflicts"
            echo "      # Resolve conflicts, then:"
            echo "      stow $pkg"
        done
    fi
fi

# Re-enable exit on error
set -e

# Only reload if packages were actually stowed
if [ ${#stowed_packages[@]} -gt 0 ]; then
    echo ""
    echo "🔄 Reloading configurations for updated packages..."
    sleep 2
    
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
        hyprctl reload 2>/dev/null || echo "    (Hyprland not running)"
    fi
    
    # Reload tmux config if tmux package was stowed
    if [ "$needs_tmux_reload" = true ]; then
        echo "  Reloading tmux config..."
        tmux source-file ~/.tmux.conf 2>/dev/null || echo "    (tmux not running)"
    fi
    
    # Reload waybar if waybar/omarchy was stowed
    if [ "$needs_waybar_reload" = true ]; then
        echo "  Reloading waybar..."
        pkill -SIGUSR2 waybar 2>/dev/null || echo "    (waybar not running)"
    fi
    
    # Reload mako if mako/omarchy was stowed
    if [ "$needs_mako_reload" = true ]; then
        echo "  Reloading mako..."
        makoctl reload 2>/dev/null || echo "    (mako not running)"
    fi
    
    # Reload zshrc if zsh package was stowed
    if [ "$needs_zsh_reload" = true ]; then
        if [ -n "$ZSH_VERSION" ] || [ "$SHELL" = "/usr/bin/zsh" ] || [ "$SHELL" = "/bin/zsh" ]; then
            echo "  Reloading .zshrc in current shell..."
            source ~/.zshrc 2>/dev/null || echo "    (failed to source .zshrc)"
        else
            echo "  .zshrc will be loaded in new zsh sessions"
        fi
    fi
    
    # Starship auto-reloads on next prompt
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

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
        echo "  ⚠️  The following native packages are installed but not in your package lists:"
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
        echo "  ⚠️  The following AUR packages are installed but not in your package lists:"
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
    sudo pacman -S --needed - < "$PKGLIST" || true
elif [ -f "$FALLBACK_PKGLIST" ]; then
    echo "  Installing native packages ($FALLBACK_PKGLIST)..."
    sudo pacman -S --needed - < "$FALLBACK_PKGLIST" || true
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
    yay -S --needed - < "$PKGLIST_AUR" || true
elif [ -f "$FALLBACK_PKGLIST_AUR" ]; then
    echo "  Installing AUR packages ($FALLBACK_PKGLIST_AUR)..."
    yay -S --needed - < "$FALLBACK_PKGLIST_AUR" || true
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
STOW_PACKAGES=(
    "alacritty-stow"
    "ghostty-stow"
    "hypr-stow"
    "kitty-stow"
    "nvim-stow"
    "omarchy-stow"
    "scripts-stow"
    "starship-stow"
    "tmux-stow"
    "zsh-stow"
)

# Map each stow package to its specific target paths that should be managed
# This prevents stow from touching other directories in .config, .local, etc.
declare -A STOW_TARGETS
STOW_TARGETS["alacritty-stow"]=".config/alacritty"
STOW_TARGETS["ghostty-stow"]=".config/ghostty"
STOW_TARGETS["hypr-stow"]=".config/hypr"
STOW_TARGETS["kitty-stow"]=".config/kitty"
STOW_TARGETS["nvim-stow"]=".config/nvim"
STOW_TARGETS["omarchy-stow"]=".config/omarchy"
STOW_TARGETS["scripts-stow"]=".local/bin"
STOW_TARGETS["starship-stow"]=".config/starship"
STOW_TARGETS["tmux-stow"]=".tmux.conf .tmux"
STOW_TARGETS["zsh-stow"]=".zshrc .zshenv .zprofile .zsh"

# Function to check if a stow package needs to be stowed
needs_stowing() {
    local pkg=$1
    local targets="${STOW_TARGETS[$pkg]}"
    
    for target in $targets; do
        local target_path="$HOME/$target"
        
        # If target doesn't exist, needs stowing
        if [ ! -e "$target_path" ] && [ ! -L "$target_path" ]; then
            return 0
        fi
        
        # If target exists but is not a symlink, needs stowing
        if [ -e "$target_path" ] && [ ! -L "$target_path" ]; then
            return 0
        fi
        
        # If target is a symlink but doesn't point to dotfiles, needs stowing
        if [ -L "$target_path" ]; then
            link_target=$(readlink "$target_path")
            if [[ ! "$link_target" =~ personal/.dotfiles/$pkg ]]; then
                return 0
            fi
        fi
    done
    
    return 1
}

# Check which packages need stowing
packages_to_stow=()
echo "  Checking stow status for each package..."

for pkg in "${STOW_PACKAGES[@]}"; do
    if [ ! -d "$pkg" ]; then
        echo "    ⚠️  Package directory not found: $pkg (skipping)"
        continue
    fi
    
    if needs_stowing "$pkg"; then
        echo "    ⚙️  $pkg needs stowing"
        packages_to_stow+=("$pkg")
    else
        echo "    ✓ $pkg already correctly stowed"
    fi
done

if [ ${#packages_to_stow[@]} -eq 0 ]; then
    echo ""
    echo "  ✓ All packages are already correctly stowed"
    stowed_packages=()
else
    echo ""
    echo "  Packages to stow: ${packages_to_stow[*]}"
    echo ""
    
    # Backup and remove only the specific targets for each package
    BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
    needs_backup=false
    
    for pkg in "${packages_to_stow[@]}"; do
        echo "  Preparing $pkg..."
        
        # Unstow first if any symlinks exist
        stow -D -t "$HOME" "$pkg" 2>/dev/null || true
        
        # Get targets for this package
        targets="${STOW_TARGETS[$pkg]}"
        
        for target in $targets; do
            target_path="$HOME/$target"
            
            # Only backup if target exists and is NOT already a correct symlink
            if [ -e "$target_path" ] || [ -L "$target_path" ]; then
                # Check if it's already a correct symlink
                is_correct_symlink=false
                if [ -L "$target_path" ]; then
                    link_target=$(readlink "$target_path")
                    if [[ "$link_target" =~ personal/.dotfiles/$pkg ]]; then
                        is_correct_symlink=true
                    fi
                fi
                
                # If not a correct symlink, back it up
                if [ "$is_correct_symlink" = false ]; then
                    if [ "$needs_backup" = false ]; then
                        mkdir -p "$BACKUP_DIR"
                        echo ""
                        echo "  Created backup directory: $BACKUP_DIR"
                        needs_backup=true
                    fi
                    
                    backup_path="$BACKUP_DIR/$target"
                    backup_dir=$(dirname "$backup_path")
                    mkdir -p "$backup_dir"
                    
                    echo "    Backing up: $target"
                    mv "$target_path" "$backup_path" 2>/dev/null || true
                fi
            fi
        done
    done
    
    # Special handling for omarchy-stow absolute symlinks
    if [[ " ${packages_to_stow[@]} " =~ " omarchy-stow " ]]; then
        echo ""
        echo "  Special handling for omarchy-stow absolute symlinks..."
        # These are runtime-generated symlinks that stow can't manage
        rm -f "$HOME/.config/omarchy/current/background" 2>/dev/null || true
        rm -f "$HOME/.config/omarchy/current/theme" 2>/dev/null || true
        [ -d "$HOME/.config/omarchy/current" ] && rmdir "$HOME/.config/omarchy/current" 2>/dev/null || true
        
        # Remove theme symlinks pointing to .local/share/omarchy
        if [ -d "$HOME/.config/omarchy/themes" ]; then
            for theme_link in "$HOME"/.config/omarchy/themes/*; do
                if [ -L "$theme_link" ]; then
                    link_target="$(readlink "$theme_link")"
                    if [[ "$link_target" =~ \.local/share/omarchy/themes ]]; then
                        echo "    Removing omarchy theme symlink: $(basename "$theme_link")"
                        rm -f "$theme_link"
                    fi
                fi
            done
        fi
    fi
    
    # Now stow all packages
    echo ""
    echo "  Creating symlinks..."
    successfully_stowed=()
    
    for pkg in "${packages_to_stow[@]}"; do
        [ -z "$pkg" ] && continue
        
        echo "    Stowing $pkg..."
        
        # Stow the package
        if stow -v -t "$HOME" "$pkg" 2>&1 | tee /tmp/stow-$pkg.log | grep -v "WARNING.*absolute symlink" | grep -q "LINK:"; then
            echo "      ✓ $pkg stowed successfully"
            successfully_stowed+=("$pkg")
        elif ! grep -q "ERROR" /tmp/stow-$pkg.log; then
            # No links created but also no errors (already stowed)
            echo "      ✓ $pkg stowed successfully"
            successfully_stowed+=("$pkg")
        else
            echo "      ✗ Failed to stow $pkg"
            echo "         Check /tmp/stow-$pkg.log for details"
        fi
    done
    
    stowed_packages=("${successfully_stowed[@]}")
    
    if [ "$needs_backup" = true ]; then
        echo ""
        echo "  📦 Backed up files to: $BACKUP_DIR"
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
            hypr-stow)
                needs_hypr_reload=true
                ;;
            tmux-stow)
                needs_tmux_reload=true
                ;;
            zsh-stow)
                needs_zsh_reload=true
                ;;
            omarchy-stow)
                needs_waybar_reload=true
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
    if printf '%s\n' "${stowed_packages[@]}" | grep -q "starship-stow"; then
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

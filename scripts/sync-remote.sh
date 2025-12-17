#!/bin/bash

cd ~/personal/.dotfiles

# Detect architecture
ARCH=$(uname -m)
if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
    ARCH_NAME="aarch64"
    echo "🐧 Updating package lists for ARM64 (aarch64)..."
elif [ "$ARCH" = "x86_64" ]; then
    ARCH_NAME="x86_64"
    echo "🐧 Updating package lists for x86_64..."
else
    ARCH_NAME="unknown"
    echo "⚠️  Unknown architecture: $ARCH"
fi

# Update shared package lists
echo "  Updating shared package lists..."
pacman -Qqen > pkglist.txt
pacman -Qqem > pkglist-aur.txt

# Update architecture-specific package lists
# Only include packages NOT in shared lists to maintain separation
if [ "$ARCH_NAME" != "unknown" ]; then
    echo "  Updating $ARCH_NAME-specific package lists (excluding shared packages)..."
    
    # Get all installed packages for this architecture
    pacman -Qqen > "/tmp/all-${ARCH_NAME}-packages.txt"
    pacman -Qqem > "/tmp/all-${ARCH_NAME}-aur.txt"
    
    # Filter out packages that are in shared lists
    comm -23 <(sort "/tmp/all-${ARCH_NAME}-packages.txt") <(sort pkglist.txt) | sort > "pkglist-${ARCH_NAME}.txt"
    comm -23 <(sort "/tmp/all-${ARCH_NAME}-aur.txt") <(sort pkglist-aur.txt) | sort > "pkglist-aur-${ARCH_NAME}.txt"
    
    # Clean up temp files
    rm -f "/tmp/all-${ARCH_NAME}-packages.txt" "/tmp/all-${ARCH_NAME}-aur.txt"
    
    echo "    → $(wc -l < "pkglist-${ARCH_NAME}.txt") architecture-specific packages"
    echo "    → $(wc -l < "pkglist-aur-${ARCH_NAME}.txt") architecture-specific AUR packages"
fi

# Check if there are changes
if [[ -n $(git status -s) ]]; then
    git add -A
    git commit -m "Auto-update ($ARCH_NAME): $(date +%Y-%m-%d\ %H:%M)"
    git push
    echo "✓ Dotfiles synced!"
else
    echo "✓ No changes to sync"
fi

echo ""
# Wait for user to press q to exit (useful for popups)
if [ -t 0 ]; then
    while true; do
        read -n 1 -s -p "Press 'q' to exit... " key
        echo
        [ "$key" = "q" ] && break || true
    done
fi

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
if [ "$ARCH_NAME" != "unknown" ]; then
    echo "  Updating $ARCH_NAME-specific package lists..."
    pacman -Qqen > "pkglist-${ARCH_NAME}.txt"
    pacman -Qqem > "pkglist-aur-${ARCH_NAME}.txt"
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

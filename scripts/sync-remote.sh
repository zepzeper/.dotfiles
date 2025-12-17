#!/bin/bash

cd ~/personal/.dotfiles

# Update package lists
pacman -Qqen > pkglist.txt
pacman -Qqem > pkglist-aur.txt

# Check if there are changes
if [[ -n $(git status -s) ]]; then
    git add -A
    git commit -m "Auto-update: $(date +%Y-%m-%d\ %H:%M)"
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
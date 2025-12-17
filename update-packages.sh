#!/bin/bash

# Native packages (explicitly installed)
pacman -Qqen > pkglist.txt

# AUR packages (explicitly installed)
pacman -Qqem > pkglist-aur.txt

# Optional: All packages with versions
pacman -Q > pkglist-full.txt

echo "Package lists updated!"

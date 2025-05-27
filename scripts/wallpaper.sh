#!/bin/zsh

# Specify the wallpaper directory
WALLPAPER_DIR="$HOME/personal/walls/"

# Check if directory exists
if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "Error: Directory $WALLPAPER_DIR does not exist" >&2
    exit 1
fi

# Find all image files in the directory (recursive search)
image_files=()
while IFS= read -r -d '' file; do
    image_files+=("$file")
done < <(find "$WALLPAPER_DIR" -type f \( \
    -iname "*.jpg" -o \
    -iname "*.jpeg" -o \
    -iname "*.png" -o \
    -iname "*.gif" \) -print0)

# Check if any images were found
if [ ${#image_files[@]} -eq 0 ]; then
    echo "Error: No images found in $WALLPAPER_DIR" >&2
    exit 1
fi

# Select a random image
random_image="${image_files[RANDOM % ${#image_files[@]}]}"

# Set the wallpaper using AppleScript
osascript <<END
tell application "System Events"
    tell every desktop
        set picture to "$random_image"
    end tell
end tell
END

echo "Wallpaper set to: $random_image"

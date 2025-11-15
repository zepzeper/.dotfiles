#!/usr/bin/bash

# Ensure rbw is unlocked
rbw unlock

# Select item and action in one go
SELECTION=$(rbw ls | awk '{print $0 " [password]\n" $0 " [username]"}' | fzf)

if [ -z "$SELECTION" ]; then
    notify-send "Cancelled" "No item selected"
    exit 0
fi

ITEM=$(echo "$SELECTION" | sed 's/ \[.*\]$//')
ACTION=$(echo "$SELECTION" | grep -o '\[.*\]' | tr -d '[]')

case "$ACTION" in
    "password")
        rbw get "$ITEM" | wl-copy
        notify-send "Password Copied" "$ITEM"
        ;;
    "username")
        rbw get --field username "$ITEM" | wl-copy
        notify-send "Username Copied" "$ITEM"
        ;;
esac

#!/usr/bin/bash

# Ensure rbw is unlocked
rbw unlock

# Select item and action in one go
SELECTION=$(rbw ls --fields name,user | awk -F'\t' '{print $1 " (" $2 ") [password]\n" $1 " (" $2 ") [username]"}' | fzf)

if [ -z "$SELECTION" ]; then
    notify-send "Cancelled" "No item selected"
    exit 0
fi

ITEM=$(echo "$SELECTION" | sed 's/ \[.*\]$//')
ACTION=$(echo "$SELECTION" | grep -o '\[.*\]' | tr -d '[]')

case "$ACTION" in
    "password")
        rbw get "$ITEM" | wl-copy --paste-once
        notify-send "Password Copied" "$ITEM"
        ;;
    "username")
        rbw get --field username "$ITEM" | wl-copy --paste-once
        notify-send "Username Copied" "$ITEM"
        ;;
esac

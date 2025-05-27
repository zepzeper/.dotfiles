#!/bin/zsh

if [[ $# -eq 1 ]]; then
    # If an argument is passed, use it as the VPN name
    selected=$1
else
    # Otherwise, let the user select the VPN using fzf
    selected=$( (/opt/homebrew/bin/tunblkctl ls) | fzf )
fi

# Exit if no VPN was selected
if [[ -z $selected ]]; then
    exit 0
fi

# Assign selected VPN to VPN_NAME variable
VPN_NAME="$selected"

# Check the VPN status
STATUS_OUTPUT=$(tunblkctl status --strip | grep -w "$VPN_NAME")

# Check if the VPN is connected or not
if echo "$STATUS_OUTPUT" | grep -q "CONNECTED"; then
    echo "VPN $VPN_NAME is connected. Disconnecting..."
    # Disconnect the VPN
    tunblkctl disconnect "$VPN_NAME"
else
    echo "VPN $VPN_NAME is not connected. Connecting..."
    # Connect the VPN
    tunblkctl connect "$VPN_NAME"
fi

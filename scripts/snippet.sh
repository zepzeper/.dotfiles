#!/usr/bin/env bash
set -euo pipefail

# Path to your secrets YAML file
SECRETS_FILE="$HOME/personal/.dotfiles/secret.yaml"

list_secrets() {
    yq eval '
      .. 
      | select(type == "!!str")
      | path | map(tostring) | join(".")
      | select(. | test("^_") | not)
    ' "$SECRETS_FILE"
}

get_secret() {
    local key="$1"
    bong get "$SECRETS_FILE" "$key" -c
}

main() {
    # Select a secret using fzf
    local selection
    selection=$(list_secrets | fzf --prompt="Select secret: ") || {
        echo "Selection cancelled."
        exit 1
    }

    local secretkey
    secretkey=$(get_secret "$selection")

    notify-send "Secret copied to clipboard!"
}

main "$@"

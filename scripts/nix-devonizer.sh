#!/run/current-system/sw/bin/zsh
#
if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find $HOME/.dotfiles/nix/dev-shells -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | fzf)
fi
if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(echo "$selected" | tr . * | tr - *)
dev_shell_path="$HOME/.dotfiles/nix/dev-shells/$selected"

# If not in tmux, just run nix develop directly in current dir
if [[ -z $TMUX ]]; then
    nix develop "$dev_shell_path" --impure
    exit 0
fi

# Create a new window in the current session, staying in current directory
tmux new-window -n "$selected_name"
tmux send-keys "nix develop $dev_shell_path --impure" C-m

#!/run/current-system/sw/bin/zsh

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find $HOME/.dotfiles/nix/dev-shells -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | fzf)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(echo "$selected" | tr . _ | tr - _)
dev_shell_path="$HOME/.dotfiles/nix/dev-shells/$selected"
tmux_running=$(pgrep tmux)

# If not inside a tmux session and no tmux sessions are running, create a new tmux session
if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s $selected_name -c "$dev_shell_path" -d
    tmux send-keys "nix develop" C-m
    tmux attach-session -t $selected_name
    exit 0
fi

# If the tmux session doesn't exist, create it (but don't exit the script)
if ! tmux has-session -t=$selected_name 2> /dev/null; then
    tmux new-session -ds $selected_name -c "$dev_shell_path"
    tmux send-keys -t $selected_name "nix develop" C-m
fi

# Switch to the session
tmux switch-client -t $selected_name

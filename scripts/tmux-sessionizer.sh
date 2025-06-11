#!/run/current-system/sw/bin/zsh

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$( (find $HOME/personal $HOME/knowledge -mindepth 1 -maxdepth 1 -type d; echo $HOME/.dotfiles;) | fzf )
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

# If not inside a tmux session and no tmux sessions are running, create a new tmux session
if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s $selected_name -c "$selected" -d
    tmux send-keys "nvim $selected" C-m
    exit 0
fi

# If the tmux session doesn't exist, create it (but don't exit the script)
if ! tmux has-session -t=$selected_name 2> /dev/null; then
    tmux new-session -ds $selected_name -c "$selected"
fi

# Switch to the new window
tmux switch-client -t $selected_name

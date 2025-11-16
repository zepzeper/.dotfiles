#!/usr/bin/env bash

# Pick project
if [[ $# -eq 1 ]]; then
    selected="$1"
else
    selected=$(find "$HOME/personal" -mindepth 1 -maxdepth 1 -type d | fzf)
fi

[[ -z "$selected" ]] && exit 0

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

# If no tmux at all is running
if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s "$selected_name" -c "$selected" -d
    tmux send-keys -t "$selected_name" "nvim $selected" C-m
    tmux attach -t "$selected_name"
    exit 0
fi

# Create the session if it does not exist
if ! tmux has-session -t "$selected_name" 2>/dev/null; then
    tmux new-session -ds "$selected_name" -c "$selected"
fi

# If already in tmux, switch
if [[ -n $TMUX ]]; then
    tmux switch-client -t "$selected_name"
else
    tmux attach -t "$selected_name"
fi

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$( (find $HOME/personal -mindepth 1 -maxdepth 1 -type d) | fzf )
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
if [[ -n $TMUX ]]; then
    tmux switch-client -t "$selected_name"
else
    tmux attach -t "$selected_name"
fi
#!/usr/bin/env bash

# Pick project
if [[ $# -eq 1 ]]; then
    selected="$1"
else
    selected=$(find "$HOME/personal" -mindepth 1 -maxdepth 1 -type d | fzf)
fi

# Exit if nothing selected
[[ -z "$selected" ]] && exit 0

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

# If no tmux at all is running, start a new session and attach
if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s "$selected_name" -c "$selected" -d
    tmux send-keys -t "$selected_name" "nvim $selected" C-m
    tmux attach -t "$selected_name"
    exit 0
fi

# If the session doesn't exist, create it (detached if not attaching now)
if ! tmux has-session -t "$selected_name" 2>/dev/null; then
    tmux new-session -ds "$selected_name" -c "$selected"
fi

# Attach or switch depending if we're in tmux
if [[ -n $TMUX ]]; then
    tmux switch-client -t "$selected_name"
else
    tmux attach -t "$selected_name"
fi

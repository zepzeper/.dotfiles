#!/bin/sh

# Get the name of the active tmux session (if any)
ACTIVE_SESSION=$(tmux list-sessions 2>/dev/null | sed -n '/(attached)/s/:.*//p')

# Check if we are in the "fivex" session
if [[ $ACTIVE_SESSION == "fivex-8_x" ]]; then
  # Create a new tmux window and send commands to it
  tmux new-window -n "Docker SSH"
  tmux send-keys "dssh" C-m
  tmux send-keys "cd /var/www/html/app/cronjobs/cluster/channels" C-m
  tmux send-keys "clear" C-m
else
  # If not in the "fivex" session, create a new window with a default name
  tmux new-window -n "New Window"
fi

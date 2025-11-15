#!/usr/bin/bash

selected=`cat ~/personal/.dotfiles/scripts/resources/.tmux-cht-languages ~/personal/.dotfiles/scripts/resources/.tmux-cht-command | fzf`
if [[ -z $selected ]]; then
    exit 0
fi

read -p "Enter query: " query

if grep -qs "$selected" ~/personal/.dotfiles/scripts/resources/.tmux-cht-languages; then
    tmux neww bash -c "curl cht.sh/$selected/$query & while [ : ]; do sleep 1; done"
else
    tmux neww bash -c "curl -s cht.sh/$selected~$query | less"
fi

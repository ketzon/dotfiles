#!/bin/bash

if [[ "$(uname)" == "Darwin" ]]; then
    FD="fd"
    DIRS=(
        "$HOME/Documents"
        "$HOME/Developer"
        "$HOME"
    )
else
    FD="fd"
    DIRS=(
        "$HOME/documents"
        "$HOME"
    )
fi

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$($FD . "${DIRS[@]}" --type=directory --max-depth=3 --full-path \
        | sed "s|^$HOME/||" \
        | sk --margin 10% --color="bw")
    [[ $selected ]] && selected="$HOME/$selected"
fi

[[ ! $selected ]] && exit 0

selected_name=$(basename "$selected" | tr . _)

if ! tmux has-session -t "$selected_name" 2>/dev/null; then
    tmux new-session -ds "$selected_name" -c "$selected"
    tmux select-window -t "$selected_name:1"
fi

tmux switch-client -t "$selected_name"

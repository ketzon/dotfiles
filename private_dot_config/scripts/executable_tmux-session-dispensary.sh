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
    # Use fzf with preview (fallback to sk if fzf not available)
    if command -v fzf &> /dev/null; then
        FUZZY="fzf"
        FUZZY_OPTS="--height 50% --layout=reverse --border --margin=1 \
            --preview 'ls -la --color=always {}' \
            --preview-window=right:50%:wrap"
    elif command -v sk &> /dev/null; then
        FUZZY="sk"
        FUZZY_OPTS="--margin 10% --color=bw"
    else
        echo "Error: Neither fzf nor sk found. Please install one of them."
        exit 1
    fi
    
    selected=$($FD . "${DIRS[@]}" --type=directory --max-depth=3 --full-path \
        | sed "s|^$HOME/||" \
        | $FUZZY $FUZZY_OPTS)
    [[ $selected ]] && selected="$HOME/$selected"
fi

[[ ! $selected ]] && exit 0

selected_name=$(basename "$selected" | tr . _)

if ! tmux has-session -t "$selected_name" 2>/dev/null; then
    tmux new-session -ds "$selected_name" -c "$selected"
    tmux select-window -t "$selected_name:1"
fi

tmux switch-client -t "$selected_name"

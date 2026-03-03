#!/usr/bin/env bash

sessions=$(tmux list-sessions -F "#{session_name}|#{session_windows}|#{session_created}" 2>/dev/null)

if [ -z "$sessions" ]; then
    echo "No tmux sessions found"
    exit 0
fi

selected=$(echo "$sessions" | awk -F'|' '{
    cmd = "date -d @" $3 " +\"%Y-%m-%d %H:%M\""
    cmd | getline created
    close(cmd)
    printf "%-20s %s windows  (created: %s)\n", $1, $2, created
}' | fzf --height 60% --layout=reverse --border \
    --header="Select sessions to kill (TAB to select multiple, ENTER to confirm)" \
    --multi \
    --preview='tmux list-windows -t {1} 2>/dev/null' \
    --preview-window=right:50%)

if [ -n "$selected" ]; then
    echo "$selected" | awk '{print $1}' | while read -r session; do
        current_session=$(tmux display-message -p '#S' 2>/dev/null)
        if [ "$session" = "$current_session" ]; then
            echo "Skipping current session: $session"
        else
            tmux kill-session -t "$session"
            echo "Killed session: $session"
        fi
    done
fi

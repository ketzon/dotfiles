#!/usr/bin/env bash

SEARCH_DIRS=(
    "$HOME/Documents"
    "$HOME"
)

find_git_repos() {
    for dir in "${SEARCH_DIRS[@]}"; do
        find "$dir" -maxdepth 4 -name ".git" -type d 2>/dev/null | sed 's|/.git$||'
    done
}

get_git_info() {
    local repo="$1"
    cd "$repo" || return
    
    local branch=$(git branch --show-current 2>/dev/null || echo "detached")
    local status=$(git status --short 2>/dev/null | wc -l)
    local commits=$(git log --oneline -n 3 2>/dev/null | head -3)
    local remote=$(git remote get-url origin 2>/dev/null | sed 's|git@github.com:|https://github.com/|' | sed 's|\.git$||')
    
    printf "Branch: %s\n" "$branch"
    printf "Changes: %s files modified\n" "$status"
    printf "Remote: %s\n\n" "${remote:-none}"
    printf "Recent commits:\n%s\n" "$commits"
}

repos=$(find_git_repos | sed "s|^$HOME/||" | sort -u)

if [ -z "$repos" ]; then
    echo "No git repositories found"
    exit 0
fi

selected=$(echo "$repos" | fzf \
    --height 80% \
    --layout=reverse \
    --border \
    --header="Select project (ENTER to open in tmux tab)" \
    --preview="$0 --preview $HOME/{}" \
    --preview-window=right:60%:wrap)

if [ "$1" = "--preview" ]; then
    get_git_info "$2"
    exit 0
fi

if [ -n "$selected" ]; then
    selected_path="$HOME/$selected"
    selected_name=$(basename "$selected" | tr . _)
    
    if [ -n "$TMUX" ]; then
        tmux new-window -n "$selected_name" -c "$selected_path"
    else
        cd "$selected_path" || exit
        if ! tmux has-session -t "$selected_name" 2>/dev/null; then
            tmux new-session -ds "$selected_name" -c "$selected_path"
        fi
        tmux attach-session -t "$selected_name"
    fi
fi

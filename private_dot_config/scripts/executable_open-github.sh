#!/usr/bin/env bash
pane_path=$(tmux display-message -p "#{pane_current_path}")
cd "$pane_path"
url=$(git remote get-url origin) 
if [[ $url == *github.com* ]]; then
    if [[ $url == git@* ]]; then
        url="${url#git@}"
        url="${url/:/\/}"
        url="${url%.git}"
        url="https://$url"
    fi
    if [[ "$(uname)" == "Darwin" ]]; then
        open "$url"
    else
        xdg-open "$url"
    fi
else
    echo "This repository is not hosted on GitHub"
fi

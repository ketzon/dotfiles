#!/bin/bash

# Créer les dossiers nécessaires
mkdir -p ~/.config

# Liens symboliques
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/nvim ~/.config/nvim
ln -sf ~/dotfiles/doom ~/.config/doom
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig

echo "Dotfiles installés !"

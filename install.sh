#!/bin/bash

# Obtenir le chemin absolu du répertoire des dotfiles
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Créer les répertoires nécessaires s'ils n'existent pas
mkdir -p "$HOME/.config/nvim"
mkdir -p "$HOME/.config/kitty"

# Créer des liens symboliques pour chaque fichier de configuration
# Pour Neovim
ln -sf "$DOTFILES_DIR/nvim" "$HOME/.config/"

# Pour les autres fichiers de configuration
ln -sf "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc"
ln -sf "$DOTFILES_DIR/.ignore" "$HOME/.ignore"
ln -sf "$DOTFILES_DIR/i3status.conf" "$HOME/.config/i3status/config"
ln -sf "$DOTFILES_DIR/kitty.conf" "$HOME/.config/kitty/kitty.conf"
ln -sf "$DOTFILES_DIR/.tags" "$HOME/.tags"

echo "Installation des dotfiles terminée !"

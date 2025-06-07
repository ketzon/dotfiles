#!/bin/bash

echo "🎓 Installing dotfiles for 42 School environment..."

# Check si on est bien dans un environnement 42
if [[ ! "$USER" =~ ^[a-z]{1,8}$ ]]; then
    echo "⚠️  Warning: This doesn't look like a 42 environment"
fi

echo "📦 Setting up local environment..."

# Créer structure locale
mkdir -p ~/.local/{bin,share,lib}
mkdir -p ~/.config

# Ajouter PATH pour binaires locaux (si pas déjà fait)
if ! grep -q "/.local/bin" ~/.zshrc 2>/dev/null; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
fi

# ===== DOOM EMACS =====
echo "📝 Setting up Doom Emacs..."
if [ ! -d ~/.emacs.d ]; then
    echo "   Installing Doom Emacs..."
    git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d
    ~/.emacs.d/bin/doom install
else
    echo "   Doom Emacs already installed"
fi

# ===== SYMLINKS =====
echo "🔗 Creating config symlinks..."

# Doom config
if [ -d ~/dotfiles/doom ]; then
    ln -sf ~/dotfiles/doom ~/.config/doom
    echo "   ✅ Doom config linked"
else
    echo "   ⚠️  ~/dotfiles/doom not found"
fi

# Neovim config
if [ -d ~/dotfiles/nvim ]; then
    ln -sf ~/dotfiles/nvim ~/.config/nvim
    echo "   ✅ Neovim config linked"
fi

# Zsh config
if [ -f ~/dotfiles/zsh/.zshrc ]; then
    ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc
    echo "   ✅ Zsh config linked"
fi

# Tmux config
if [ -f ~/dotfiles/tmux/.tmux.conf ]; then
    ln -sf ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf
    echo "   ✅ Tmux config linked"
fi

# Git config
if [ -f ~/dotfiles/git/.gitconfig ]; then
    ln -sf ~/dotfiles/git/.gitconfig ~/.gitconfig
    echo "   ✅ Git config linked"
fi

# Kitty config
if [ -d ~/dotfiles/kitty ]; then
    ln -sf ~/dotfiles/kitty ~/.config/kitty
    echo "   ✅ Kitty config linked"
fi

# ===== DOOM SYNC =====
if [ -d ~/.emacs.d ]; then
    echo "🔄 Syncing Doom Emacs..."
    ~/.emacs.d/bin/doom sync
fi

# ===== OH-MY-ZSH (optionnel) =====
if [ ! -d ~/.oh-my-zsh ]; then
    echo "🐚 Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

echo ""
echo "✅ Dotfiles installation complete!"
echo "🔄 Restart your terminal or run: source ~/.zshrc"
echo "📝 Your Doom Emacs config is ready to use!"

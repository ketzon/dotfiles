# Améliorations de l'environnement Chezmoi

## 🎯 Problème résolu : Fuzzy Find dans tmux

### Cause
- Absence de `default-terminal` dans tmux.conf
- Script `tmux-session-dispensary.sh` utilisait `sk` au lieu de `fzf`
- Configuration FZF manquante dans zshrc

### Solutions appliquées

#### 1. **tmux.conf** ✅
- ✅ Ajout `default-terminal "tmux-256color"`
- ✅ Ajout `escape-time 0` pour meilleure réactivité
- ✅ Activation support souris (`mouse on`)
- ✅ Correction chemin reload config
- ✅ Message de confirmation reload

#### 2. **Script tmux-session-dispensary** ✅
- ✅ Détection automatique fzf/sk avec fallback
- ✅ Preview des répertoires avec `ls -la`
- ✅ Interface améliorée (bordure, layout reverse)
- ✅ Message d'erreur si aucun fuzzy finder disponible

#### 3. **zshrc amélioré** ✅
- ✅ Variables FZF optimisées :
  - `FZF_DEFAULT_OPTS` : interface moderne
  - `FZF_CTRL_T_OPTS` : preview fichiers avec bat
  - `FZF_ALT_C_OPTS` : preview répertoires
  - `FZF_TMUX=1` : mode popup tmux
- ✅ Alias organisés par catégorie
- ✅ Alias git ajoutés (gs, ga, gc, gp, gl)
- ✅ Alias utilitaires (ls, ll, grep avec couleurs)
- ✅ Correction paths hardcodés

## 🚀 Améliorations chezmoi

### Templates pour portabilité
- `dot_gitconfig.tmpl` : utilise `{{ .chezmoi.homeDir }}`
- `dot_zshrc.tmpl` : chemins dynamiques selon OS
- Support multi-OS (Linux/macOS)

### Configuration chezmoi.toml
- Options git (autocommit, autopush)
- Configuration merge avec nvim
- Options diff

### Fichiers ajoutés
- `.chezmoiignore` : exclut fichiers temporaires, cache, IDE
- `run_once_install-packages.sh.tmpl` : script d'installation automatique
  - Détecte OS (Linux/macOS)
  - Installe packages essentiels (fzf, fd, ripgrep, bat, etc.)
  - Configure Oh My Zsh et plugins
  - Setup fzf keybindings

## 📝 Pour utiliser

### Appliquer les changements
```bash
# Voir les changements
chezmoi diff

# Appliquer
chezmoi apply

# Recharger tmux (dans tmux)
Ctrl+Space puis r

# Recharger zsh
source ~/.zshrc
```

### Tester fzf dans tmux
```bash
# Ouvrir tmux
tmux

# Tester fuzzy find fichiers
Ctrl+T

# Tester fuzzy find répertoires
Alt+C

# Tester script session dispensary
Ctrl+Space puis f
```

### Installer sur nouvelle machine
```bash
chezmoi init --apply https://github.com/VOTRE_USERNAME/dotfiles.git
# Le script run_once installera automatiquement les dépendances
```

## 🔧 Variables FZF configurées

| Variable | Fonction |
|----------|----------|
| `FZF_DEFAULT_OPTS` | Interface (hauteur 60%, bordure, reverse layout) |
| `FZF_DEFAULT_COMMAND` | Utilise `fd` au lieu de `find` |
| `FZF_CTRL_T_COMMAND` | Recherche fichiers avec fd |
| `FZF_CTRL_T_OPTS` | Preview avec bat (coloration syntaxe) |
| `FZF_ALT_C_COMMAND` | Recherche répertoires avec fd |
| `FZF_ALT_C_OPTS` | Preview répertoires avec ls |
| `FZF_TMUX` | Active mode popup tmux |
| `FZF_TMUX_OPTS` | Popup 80% largeur/hauteur |

## 📦 Packages recommandés

Si pas installés automatiquement :
```bash
# Ubuntu/Debian
sudo apt install fzf fd-find ripgrep bat zsh tmux neovim git

# macOS
brew install fzf fd ripgrep bat zsh tmux neovim git
```

## 🎨 Améliorations futures possibles

- [ ] Intégration tmux navigator pour navigation seamless nvim ↔ tmux
- [ ] Thème tmux personnalisé
- [ ] Plus de plugins nvim (voir lazy.nvim)
- [ ] Gestion secrets avec age encryption
- [ ] Scripts post-install par type de machine (dev/perso)
- [ ] Aliases git plus avancés (gco, gst, etc.)

---

## 🔧 Corrections appliquées suite aux retours

### Problème 1: Script tmux créait session isolée ❌ → Crée tab maintenant ✅

**Avant :** `Ctrl+Space f` créait une nouvelle session tmux isolée  
**Maintenant :** Crée une nouvelle window (tab) dans votre session actuelle

**Comportement :**
- Si vous êtes **dans tmux** → Crée un nouveau tab
- Si vous êtes **hors tmux** → Crée/attache à une session

### Problème 2: FZF ne cherchait pas dans home ❌ → Cherche partout maintenant ✅

**Avant :** `Ctrl+T` cherchait uniquement dans le répertoire courant  
**Maintenant :** Cherche dans tout votre `$HOME` (~530k fichiers indexés)

**Variables corrigées :**
```bash
FZF_CTRL_T_COMMAND='fd --type f --hidden --follow --exclude .git . $HOME'
FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git . $HOME'
```

### Problème 3: Preview ls causait erreurs → Fallbacks ajoutés ✅

**Preview fichiers :** `bat` (avec couleurs) ou `cat` (fallback)  
**Preview répertoires :** `tree` (arborescence) ou `find` (fallback)

---

## 🎮 Utilisation

### Dans le shell
```bash
# Fuzzy find fichiers dans tout le home
Ctrl+T

# Fuzzy find répertoires
Alt+C

# Historique des commandes
Ctrl+R
```

### Dans tmux
```bash
# Ouvrir session dispensary (crée nouveau tab)
Ctrl+Space puis f

# Recharger config tmux
Ctrl+Space puis r

# Lister tous les tabs
Ctrl+Space puis w
```

### Pour recharger les configs
```bash
# Recharger zsh (nouvelles variables FZF)
source ~/.zshrc

# Ou redémarrer le shell
exec zsh
```

---

## 📊 Statistiques

- **Fichiers indexés dans home :** ~530,978 fichiers
- **Vitesse de recherche :** Instantanée grâce à `fd`
- **Preview :** Activé avec fallbacks multiples


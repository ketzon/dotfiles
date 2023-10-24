" custom snippet pour ecrire printf
nnoremap ,p :-1read $HOME/.vim/.skeleton<CR>f";;a

" update mon path pour jump dans chaque file, sans me deplacer avec des cd partout
set path+=**

" affiche le nom des fichiers quand j'utilise tab, combine avec :find
set wildmenu

" tab a 4 espace
set ts=4

" command-line mode history
set history=200

" numero de ligne
set number

" numero relatif pour jump rapidement a la vertical
set relativenumber

" curseur au meme niveau de la ligne ou je viens
set autoindent

" pas de recherche highlight
set nohlsearch

" auto-save des fichiers cache
set hidden

" pas de .swp 
set noswapfile

" autosave
set autowrite

" 42 header norm
let g:user42 = 'fbesson'
let g:mail42 = 'fbesson@student.42.fr'

" debugger built-in vim
if version >= 801
	packadd termdebug
endif

" open quickfix list pour debug
noremap <leader>cw :botright :cw<cr>

" run make en mode silence
noremap <leader>m :silent! :make! \| :redraw!<cr>

" ajoute zz a la fin d'un jump pour centrer l'ecran
nnoremap <C-U> <C-U>zz
nnoremap <C-D> <C-D>zz
nnoremap <C-]> <C-]>zz
nnoremap <C-o> <C-o>zz
nnoremap <C-i> <C-i>zz

execute pathogen#infect()

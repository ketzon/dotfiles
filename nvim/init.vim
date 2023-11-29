lua require('config')
lua require('remap')
set clipboard=unnamedplus
set mouse=a
set wildmenu
" syntax on
set background=dark
set ts=4
set history=200
set number
set relativenumber
set autoindent
set nohlsearch
set inccommand=split
set hidden
set completeopt=noinsert,menuone,noselect
set ttimeoutlen=0
set noswapfile
set title
set autowrite
let g:user42 = 'fbesson'
let g:mail42 = 'fbesson@student.42.fr'
noremap <leader>cw :botright :cw<cr>
noremap <leader>m :silent! :make! \| :redraw!<cr>
nnoremap <C-U> <C-U>zz
nnoremap <C-D> <C-D>zz
nnoremap <C-]> <C-]>zz
nnoremap <C-o> <C-o>zz
nnoremap <C-i> <C-i>zz
filetype plugin indent on
" packloadall
set grepprg=rg\ --vimgrep\ --no-heading
silent! helptags ALL

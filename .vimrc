set history=200
set number
set relativenumber
set autoindent
set hlsearch
set incsearch
set hidden
set noswapfile
set autowrite

let g:user42 = 'fbesson'
let g:mail42 = 'fbesson@student.42.fr'

if version >= 801
	packadd termdebug
endif

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l


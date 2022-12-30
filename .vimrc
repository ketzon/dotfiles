set history=200
set number
set relativenumber
set autoindent
set hlsearch
set incsearch
set hidden

let g:user42 = 'fbesson'
let g:mail42 = 'fbesson@student.42.fr'

if version >= 801
	packadd termdebug
endif

map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

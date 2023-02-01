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

" J'utilise quickfix mapping a la place de ack
let g:ack_apply_qmappings = 0
let g:ack_apply_lmappings = 0
let g:qf_mapping_ack_style = 1

" J'utilise quickfixmapping a la place de unimpaired
let g:nremap = {"[q": "", "]q": "", "[l": "", "]l": ""}
nmap [q <Plug>(qf_qf_previous)
nmap ]q <Plug>(qf_qf_next)
nmap [l <Plug>(qf_loc_previous)
nmap ]l <Plug>(qf_loc_next)


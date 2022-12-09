" integrate system clipboard
set clipboard=unnamed

" show line number
set number
" show position
set ruler

" highlight searched
set hlsearch

set ignorecase
set smartcase

" the default position of new splitted window
set splitbelow
set splitright

" recommended keymap
nnoremap <c-\> :vsplit<CR>
inoremap <c-\> <Esc>:vsplit<CR>
vnoremap <c-\> <Esc>:vsplit<CR>

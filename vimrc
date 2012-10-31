autocmd! bufwritepost .vimrc source %

syn on

"set mouse=a

set number
set tabstop=4
set showtabline=2
set wildmenu

set clipboard=unnamed

set cursorline

map <c-x> :quit!<cr>
map <c-w> :w<cr>

inoremap <c-@> <c-x><c-n>

set history=1000
set undolevels=1000

set incsearch
set ignorecase
set smartcase

set noswapfile
set nobackup
set nowritebackup


set ttyfast
set laststatus=2
set autoindent
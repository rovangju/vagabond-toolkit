autocmd! bufwritepost .vimrc source %                                                                                                                                  |" Press <F1>, ? for help
autocmd  vimenter * TagbarToggle                                                                                                                                       |
                                                                                                                                                                       |▶ maps
" Install Git Plug                                                                                                                                                     |~
"curl -fLo ~/.vim/autoload/plug.vim --create-dirs \                                                                                                                    |~
"    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim                                                                                               |~
                                                                                                                                                                       |~
set encoding=utf-8                                                                                                                                                     |~
set history=1000                                                                                                                                                       |~
                                                                                                                                                                       |~
filetype plugin on                                                                                                                                                     |~
filetype indent on                                                                                                                                                     |~
                                                                                                                                                                       |~
syn on                                                                                                                                                                 |~
set nu                                                                                                                                                                 |~
set ts=4                                                                                                                                                               |~
set t_Co=256                                                                                                                                                           |~
set laststatus=2                                                                                                                                                       |~
set showtabline=2                                                                                                                                                      |~
set cmdheight=2                                                                                                                                                        |~
set wildmenu                                                                                                                                                           |~
set ruler                                                                                                                                                              |~
set ignorecase                                                                                                                                                         |~
set hlsearch                                                                                                                                                           |~
set noerrorbells                                                                                                                                                       |~
set novisualbell                                                                                                                                                       |~
                                                                                                                                                                       |~
set wildmode=longest:full,full                                                                                                                                         |~
                                                                                                                                                                       |~
                                                                                                                                                                       |~
call plug#begin('~/.vim/plugged')                                                                                                                                      |~
                                                                                                                                                                       |~
Plug 'bling/vim-airline'                                                                                                                                               |~
"Plug 'crusoexia/vim-monokai'                                                                                                                                           |~
Plug 'scrooloose/nerdtree'                                                                                                                                             |~
Plug 'pangloss/vim-javascript'                                                                                                                                         |~
Plug 'majutsushi/tagbar'                                                                                                                                               |~
Plug 'airblade/vim-gitgutter'                                                                                                                                          |~
Plug 'mattn/emmet-vim'                                                                                                                                                 |~
Plug 'tpope/vim-fugitive'
Plug 'blueshirts/darcula'
call plug#end()                                                                                                                                                        |~
                                                                                                                                                                       |~
colorscheme darcula                                                                                                                                                    |~
                                                                                                                                                                       |~
map <C-o> :NERDTreeToggle<CR>                                                                                                                                          |~
map <C-n> :bNext<CR>                                                                                                                                                   |~
nmap <F8> :TagbarToggle<CR>         

autocmd bufwritepost .vimrc source %
autocmd  vimenter * TagbarToggle

" 0. re-map 'vi' to 'vim' in .bashrc (alias vi='vim')
" 1. Install Git Plug: curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" 2. Run 'PlugInstall'
" 3. Re-run vim

" Emmet expansion: <C-Y> ,
" Toggle file-nav: <C-o>
" Toggle Tag-bar: <F8>

set encoding=utf-8
set history=1000

filetype plugin on
filetype indent on

syn on
set nu
set ts=4
set t_Co=256
set laststatus=2
set showtabline=2
set cmdheight=2
set wildmenu
set ruler
set ignorecase
set hlsearch
set noerrorbells
set novisualbell

set wildmode=longest:full,full


call plug#begin('~/.vim/plugged')

Plug 'bling/vim-airline'
"Plug 'crusoexia/vim-monokai'
Plug 'scrooloose/nerdtree'
Plug 'pangloss/vim-javascript'
"Plug 'majutsushi/tagbar'
Plug 'airblade/vim-gitgutter'
"Plug 'mattn/emmet-vim'
Plug 'blueshirts/darcula'
Plug 'tpope/vim-fugitive'
call plug#end()


map <C-o> :NERDTreeToggle<CR>
map <C-n> :bNext<CR>
nmap <F8> :TagbarToggle<CR>

colorscheme darcula

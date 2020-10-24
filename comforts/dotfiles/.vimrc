autocmd bufwritepost .vimrc source %

" 0. re-map 'vi' to 'vim' in .bashrc (alias vi='vim')
" 1. Install Git Plug: curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" 2. Run 'PlugInstall'
" 3. Re-run vim

set encoding=utf-8
set history=1000
set colorcolumn=120
highlight ColorColumn ctermbg=lightgray

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
set paste

set wildmode=longest:full,full

" Make sure git is installed 

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'bling/vim-airline'
Plug 'airblade/vim-gitgutter'
Plug 'blueshirts/darcula'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
call plug#end()

colorscheme darcula

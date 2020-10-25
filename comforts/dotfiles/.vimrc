autocmd bufwritepost .vimrc source %


" 0. re-map 'vi' to 'vim' in .bashrc (alias vi='vim')
" 1. Install Git Plug: curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" 2. Run 'PlugInstall'
" 3. Re-run vim

highlight ColorColumn ctermbg=lightgray
filetype plugin indent on
syntax on

set termguicolors

set encoding=utf-8
set history=1000
set colorcolumn=120

"no .swp file
set nobackup

"show line numbers
set nu

"4 space tabs
set ts=4

set cursorline
set laststatus=2
set showtabline=2
set cmdheight=2
set wildmenu
set ruler
set shell=/usr/bin/zsh 
set ignorecase
set smartcase
set hlsearch
set noerrorbells
set novisualbell
set paste
set autoindent
set wildmode=longest:full,full

let g:taboo_tab_format = " %f%m (%W) "

" Make sure git is installed 
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Respects editorconfig
Plug 'editorconfig/editorconfig-vim'

"Shows indent line alignment
Plug 'Yggdroot/indentLine'

"Easy commenting ([n]\cc, [n]\cs [n]\cn, \c$)
Plug 'scrooloose/nerdcommenter'

" Show pct of line in file/line/columns on bottom
Plug 'bling/vim-airline'

"Show git status of file
Plug 'airblade/vim-gitgutter'

" Theme that I like 
Plug 'blueshirts/darcula'
Plug 'arcticicestudio/nord-vim'

" :Gedit, :Git x (:help fugitive) 
Plug 'tpope/vim-fugitive'

"FZF! Fuzzy file finding, :Buffers, :Files, :History, :Windows, :Commits, etc 
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Easy bracket pair management [ => []  and z[<bs>] = z
Plug 'jiangmiao/auto-pairs'

" Language packs to help with syntax, indentation
Plug 'sheerun/vim-polyglot'

" Icons added to finders/trees
"Plug 'ryanoasis/vim-devicons'

" Nifty way to jump to symbols on screen (\\ss)
Plug 'easymotion/vim-easymotion'

Plug 'gcmt/taboo.vim'
call plug#end()

colorscheme darcula


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" KEYBINDINGS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" explore folder of current buffer
nnoremap - :FZF %:h<CR>
" Use control-c instead of escape
nnoremap <C-c> <Esc>
" ctrl-s to save (MUST HAVE stty -ixon in zshrc file!
nnoremap <C-s> :w<CR>
" Alternate way to quit, ctrl-q
nnoremap <C-Q> :wq!<CR>

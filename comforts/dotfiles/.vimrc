autocmd bufwritepost .vimrc source %

filetype plugin indent on
syntax on

set clipboard=unnamed
set history=1000
set colorcolumn=120

"no .swp file
set nobackup
"show hybrid lines 
set nu 

"4 space tabs
set ts=4
set shiftwidth=4

set cursorline
set laststatus=2
set showtabline=2
set wildmenu
set ruler
set shell=$SHELL
set ignorecase
set smartcase
set hlsearch
set noerrorbells
set novisualbell
set paste
set smartindent 
set wildmode=longest:full,full

let g:airline_theme = 'base16'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#fugitiveline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_skip_empty_sections = 1

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

" https://github.com/preservim/nerdcommenter
"Easy commenting (<leader>cc, <leader>cs, <leader>cu, <leader>cn, <leader>c$, <leader>c-space)
Plug 'scrooloose/nerdcommenter'

" Show pct of line in file/line/columns on bottom
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Git integration
Plug 'tpope/vim-fugitive'

"FZF! Fuzzy file finding, :Buffers, :Files, :History, :Windows, :Commits, etc
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Language packs to help with syntax, indentation
" Disabled: Cuasing issues with pasting 
" Plug 'sheerun/vim-polyglot'

" Nifty way to jump to symbols on screen (<leader><leader>s)
Plug 'easymotion/vim-easymotion'

" Base 16 vim theme support
Plug 'chriskempson/base16-vim'

call plug#end()

if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" KEYBINDINGS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use control-c instead of escape
nnoremap <C-c> <Esc>
" ctrl-s to save (MUST HAVE stty -ixon in zshrc file!
nnoremap <C-s> :w<CR>
" Alternate way to quit, ctrl-q
nnoremap <C-q> :wq!<CR>

let mapleader=","
nnoremap <silent> <Leader>n :bn<CR>
" explore folder of current buffer
nnoremap <silent> <Leader>f :Files<CR>
" explore folder of home
nnoremap <silent> <Leader>F :Files ~/<CR>
" toggle relative line numbers
nnoremap <silent> <Leader>rn :set rnu!<CR>

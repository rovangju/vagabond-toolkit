autocmd bufwritepost .vimrc source %
set backspace=indent,eol,start

set clipboard=unnamed
set history=1000
set colorcolumn=120
set conceallevel=1

"no .swp file
set nobackup
"show hybrid lines
set nu

"space tabs
set expandtab
set ts=2
set shiftwidth=2

set mouse=a
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
set smartindent
set wildmode=longest:full,full

" Encoding
set encoding=utf-8
set binary
set ttyfast

set nocompatible
filetype plugin indent on
" has to be after filetype
syntax on
" faster scroll when syntax on
set lazyredraw

" Make sure git is installed
if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
				\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Surround help - cs = change surround, e.g.: cs"' - change surrounding " to '
Plug 'tpope/vim-surround'

" Respects editorconfig
Plug 'editorconfig/editorconfig-vim'

" https://github.com/preservim/nerdcommenter
"Easy commenting (<leader>cc, <leader>cs, <leader>cu, <leader>cn, <leader>c$, <leader>c-space)
Plug 'scrooloose/nerdcommenter'

" Show pct of line in file/line/columns on bottom
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Git integration
Plug 'airblade/vim-gitgutter'

"FZF! Fuzzy file finding, :Buffers, :Files, :History, :Windows, :Commits, etc
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Language packs to help with syntax, indentation
Plug 'sheerun/vim-polyglot'
" If issues take a look at let g:polyglot_disabled = ['autoindent']

" Nifty way to jump to symbols on screen (<leader><leader>s)
Plug 'easymotion/vim-easymotion'

" Base 16 vim theme support
Plug 'chriskempson/base16-vim'

" Remove trailing
Plug 'ntpeters/vim-better-whitespace'

" Cute filetype icons
Plug 'ryanoasis/vim-devicons'

Plug 'ConradIrwin/vim-bracketed-paste' " set paste mode automatically to avoid indentation issues
"Plug 'sickill/vim-pasta' " Pasting with indentation context

" :Copilot setup to start
"Plug 'github/copilot.vim'

" mg979/vim-visual-multi

" Visual feedback for yanks
Plug 'machakann/vim-highlightedyank'

call plug#end()

if filereadable(expand("~/.vimrc_background"))
	let base16colorspace=256
	source ~/.vimrc_background
endif

let g:strip_only_modified_lines=1
let g:strip_whitespace_on_save=1
let g:strip_whitespace_confirm=0

let g:airline_theme = 'base16'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#fugitiveline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_skip_empty_sections = 1

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
nnoremap <silent> <Leader>fb :Files<CR>
" explore folder of home
nnoremap <silent> <Leader>fh :Files ~/<CR>


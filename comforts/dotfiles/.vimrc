autocmd bufwritepost .vimrc source %

filetype plugin indent on
syntax on

set history=1000
set colorcolumn=120

"no .swp file
set nobackup

"show hybrid lines 
set nu rnu

"4 space tabs
set ts=4

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
set autoindent
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

"Easy commenting ([n]\cc, [n]\cs [n]\cn, \c$)
Plug 'scrooloose/nerdcommenter'

" Show pct of line in file/line/columns on bottom
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Git integration
Plug 'tpope/vim-fugitive'

"FZF! Fuzzy file finding, :Buffers, :Files, :History, :Windows, :Commits, etc
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Easy bracket pair management [ => []  and z[<bs>] = z
Plug 'jiangmiao/auto-pairs'

" Language packs to help with syntax, indentation
Plug 'sheerun/vim-polyglot'

" Nifty way to jump to symbols on screen (\\ss)
Plug 'easymotion/vim-easymotion'

" Base 16 vim theme support
Plug 'chriskempson/base16-vim'

" Relative line numbers; but when in insert mode, use absolute
Plug 'jeffkreeftmeijer/vim-numbertoggle'

call plug#end()

if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif


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
nnoremap <C-q> :wq!<CR>

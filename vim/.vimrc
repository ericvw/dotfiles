" .vimrc - Personal vim configuration
" vim: nowrap:sw=4:sts=4

" Better to be safe than sorry.
set nocompatible

" Core options
" Run :options to understand grouping of settings.

" 1 important
set pastetoggle=<F2>

" 2 moving around, searching and patterns
set incsearch
set ignorecase
set smartcase

" 4 displaying text
set scrolloff=1
set display+=lastline
set lazyredraw
set list
set listchars=tab:»\ ,trail:·,extends:>,precedes:<
set number

" 5 syntax, highlighting and spelling
if has('autocmd')
    filetype plugin indent on
endif
if has('syntax') && !exists('g:syntax_on')
    syntax enable
endif
if exists("&colorcolumn")
    set colorcolumn=+1
endif

" 6 multiple windows
set laststatus=2
set splitright
set splitbelow

" 8 terminal
set ttyfast

" 9 using the mouse
set mouse=a

" 11 message and info
set shortmess=atToOI
set showcmd
set ruler
set report=0
set noerrorbells

" 13 editing text
if has("persistent_undo")
    set undofile
    set undodir=~/.vim/tmp/undo
endif
set backspace=indent,eol,start
set formatoptions+=j
set showmatch

" 14 tabs and indenting
set shiftwidth=4
set smarttab
set softtabstop=4
set shiftround
set expandtab
set autoindent
set cinoptions=:0.5s,=0.5s,l1,g0.5s,h0.5s,N-s,t0,i0,(0,J1
"              |     |     |  |     |     |   |  |  |  +-- don't confuse JS object decls with labels
"              |     |     |  |     |     |   |  |  +-- indent from unclosed parens
"              |     |     |  |     |     |   |  +-- C++ base class decls and initializations
"              |     |     |  |     |     |   +-- indent function return type at margin
"              |     |     |  |     |     +-- indent inside C++ namespace
"              |     |     |  |     +-- places statements after C++ scope decls
"              |     |     |  +--  place C++ scope declarations
"              |     |     +-- align with case label instead of statement
"              |     +-- place statements after case label
"              +-- placement of case after switch statement

" 18 reading and writing files
set nobomb
set fileformats+=mac
set backup
set backupdir=~/.vim/tmp/backup
set autoread

" 20 command line editing
set history=1000
set wildmenu
set wildmode=list:longest,full
set wildignore+=*.pyc " Python byte code.
set wildignore+=*.o " Compiled object files.

" 24 multi-byte characters
set encoding=utf-8

" Key mapppings

" Disable highlight after search.
noremap <silent> <leader><space> :set hlsearch! <CR>

" Toggle spell check.
nmap <silent> <leader>sc :set spell!<CR>

" Show highlighting groups for current word.
nmap <C-N> :call <SID>SynStack()<CR>
function! <SID>SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line("."), col(".")), "synIDattr(v:val, 'name')")
endfunc

" Strip whitespace.
map <silent> <leader>ss :
    \ let save_cursor = getpos(".") <Bar>
    \ let old_query = getreg('/') <Bar>
    \ %s/\s\+$//e <Bar>
    \ call setpos('.', save_cursor) <Bar>
    \ call setpos('/', old_query) <CR>

" Jump to the last cursor position in file if possible.
autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit' |
    \     exe "normal! g`\"" |
    \ endif

"  Plugins

" Auto-bootstrap vim-plug.
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

Plug 'airblade/vim-gitgutter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'itchyny/lightline.vim'
Plug 'mbbill/undotree'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'dense-analysis/ale'
Plug 'nordtheme/vim', {'as': 'nordtheme'}
Plug 'fladson/vim-kitty'

call plug#end()

" Plugin settings

" Lightline
let g:lightline = {
    \ 'colorscheme': 'nord',
    \ }

" Undotree
nnoremap <silent> <leader>u :UndotreeToggle<CR>
let g:undotree_SetFocusWhenToggle=1
let g:undotree_WindowLayout=2

" ALE
nmap <silent> <leader>aj :ALENextWrap<cr>
nmap <silent> <leader>ak :ALEPreviousWrap<cr>

" Local customizations

let g:nord_italic = 1
let g:nord_italic_comments = 1
let g:nord_underline = 1
colorscheme nord

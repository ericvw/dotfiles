" .vimrc - Personal vim configuration
" vim: nowrap:sw=4:sts=4
" Run :options to understand grouping of settings.

" Better to be safe than sorry.
set nocompatible

" Bundle configuration (Vundle).
if filereadable(expand("~/.vimrc.bundles"))
    source ~/.vimrc.bundles
endif

"""""""""""""""""""""""""
" Beginning of :options "
"""""""""""""""""""""""""

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

" 20 command line editing
set history=1000
set wildmenu
set wildmode=list:longest,full
set wildignore+=*.pyc

" 24 multi-byte characters
set encoding=utf-8

"""""""""""""""""""
" End of :options "
"""""""""""""""""""

" Change mapleader.
let mapleader=","

" Move up and down by screen lines.
nnoremap k gk
nnoremap j gj

" Easier window navigation/manipulation.
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

" Disable highlight after search.
noremap <silent> <leader><space> :set hlsearch! <CR>

" Strip whitespace.
map <silent> <leader>ss :
    \ let save_cursor = getpos(".") <Bar>
    \ let old_query = getreg('/') <Bar>
    \ %s/\s\+$//e <Bar>
    \ call setpos('.', save_cursor) <Bar>
    \ call setpos('/', old_query) <CR>

" Toggle syntax on/off.
map <silent> <leader>sy :
    \ if exists("g:syntax_on") <Bar>
    \   syntax off <Bar>
    \ else <Bar>
    \   syntax enable <Bar>
    \ endif <CR>

" Toggle spell check.
nmap <silent> <leader>sc :set spell!<CR>

" Jump to the last cursor position in file if possible.
function! ResumeCursor()
    if line("'\"") <= line("$")
        normal! g`"
    endif
endfunction
augroup resumeCursor
    autocmd!
    autocmd BufWinEnter * call ResumeCursor()
augroup END

" Plugin mappings.
nnoremap <silent> <leader>u :UndotreeToggle<CR>
nnoremap <Leader>g :YcmCompleter GoTo<CR>

" Do not check on close.
let g:syntastic_check_on_wq=0

" Jump focus into the undo tree.
let g:undotree_SetFocusWhenToggle=1
let g:undotree_WindowLayout=2

" Source local override file if one exists.
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif

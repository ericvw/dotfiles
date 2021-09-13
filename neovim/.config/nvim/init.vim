" init.vim - Personal nvim configuration
" vim: nowrap:sw=4:sts=4

"""""""""""""""""""""""""""""""
" Options Grouped by Function "
"""""""""""""""""""""""""""""""
" Run :options to understand grouping of settings.

" 1 important
set pastetoggle=<F2>

" 2 moving around, searching and patterns
set ignorecase
set smartcase

" 4 displaying text
set scrolloff=1
set lazyredraw
set list
set listchars=tab:»\ ,trail:·,extends:>,precedes:<
set number

" 5 syntax, highlighting and spelling
set colorcolumn=+1

" 6 multiple windows
set splitright
set splitbelow

" 9 using the mouse
set mouse=a

" 11 message and info
set shortmess+=aI
set report=0
set noerrorbells

" 13 editing text
set undofile
set showmatch

" 14 tabs and indenting
set shiftwidth=4
set softtabstop=4
set shiftround
set expandtab
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
set backupdir-=.
for d in split(&backupdir, ',')
    if !isdirectory(expand(d))
        call mkdir(expand(d), 'p')
    endif
endfor

" 20 command line editing
set wildmode=list:longest,full
set wildignore+=*.pyc " Python byte code.
set wildignore+=*.o " Compiled object files.

""""""""""""""""
" Key Mappings "
""""""""""""""""

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

" Show highlighting groups for current word.
nmap <C-N> :call <SID>SynStack()<CR>
function! <SID>SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line("."), col(".")), "synIDattr(v:val, 'name')")
endfunc

""""""""""""""""""""""
" Automatic Commands "
""""""""""""""""""""""

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

""""""""""""""""""""""""
" Local Customizations "
""""""""""""""""""""""""

colorscheme dim-ansi

"  Source plugins.
"if filereadable(expand("~/.vimrc.plugins"))
"    source ~/.vimrc.plugins
"endif

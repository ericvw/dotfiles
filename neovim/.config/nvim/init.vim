" init.vim - Personal nvim configuration
" vim: nowrap:sw=4:sts=4

" User configuration that has an equivalent Lua API are factored in modules
" under the 'config' namespace.  Otherwise, it is configured via Vimscript.

" Core options
lua require("config/options")

" Key mappings
lua require("config/key-mappings")

" Strip whitespace.
" XXX: Port this to config/key-mappings.lua once key mapping can call Lua
"       functions.
map <silent> <leader>ss :
    \ let save_cursor = getpos(".") <Bar>
    \ let old_query = getreg('/') <Bar>
    \ %s/\s\+$//e <Bar>
    \ call setpos('.', save_cursor) <Bar>
    \ call setpos('/', old_query) <CR>

""""""""""""""""""""""
" Automatic Commands "
""""""""""""""""""""""

" Jump to the last cursor position in file if possible.
autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit' |
    \     exe "normal! g`\"" |
    \ endif

""""""""""""""""""""""""
" Local Customizations "
""""""""""""""""""""""""

colorscheme dim-ansi

"""""""""""
" Plugins "
"""""""""""

" Auto-bootstrap vim-plug.
let vim_plug = stdpath('data') . "/site/autoload/plug.vim"
if empty(glob(vim_plug))
    silent execute '!curl -fLo '.vim_plug.' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(stdpath('data') . '/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'elzr/vim-json'
Plug 'itchyny/lightline.vim'
Plug 'mbbill/undotree'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-git'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'dense-analysis/ale'

call plug#end()

nnoremap <silent> <leader>u :UndotreeToggle<CR>
let g:undotree_SetFocusWhenToggle=1
let g:undotree_WindowLayout=2

nmap <silent> <leader>aj :ALENextWrap<cr>
nmap <silent> <leader>ak :ALEPreviousWrap<cr>

" XXX: Keep this around once the dim-ansi colorscheme settles for the Diff*
"      higlight groups.
" gitgutter's original colors
" highlight GitGutterAdd    ctermfg=2
" highlight GitGutterChange ctermfg=3
" highlight GitGutterDelete ctermfg=1

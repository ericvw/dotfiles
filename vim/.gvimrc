" .gvimrc - personal g(ui)vim configuration

" remove the toolbar
set guioptions-=T
" use consolas font if available
set guifont=Inconsolata:h14
" hide mouse pointer while typing
set mousehide

" source local override file if one exists
if filereadable(expand("~/.gvimrc.local"))
  source ~/.gvimrc.local
endif

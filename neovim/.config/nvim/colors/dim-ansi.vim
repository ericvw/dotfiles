" Vim color file
" Maintainer: Eric N. Vander Weele

highlight clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "dim-ansi"

" Default groups
highlight Conceal                     ctermfg=7  ctermbg=8
highlight CursorColumn                           ctermbg=7
" highlight CursorLine                             ctermbg=238
" highlight CursorColumn                           ctermbg=238
" highlight DiffAdd           cterm=bold  ctermfg=0  ctermbg=2
" highlight DiffChange        cterm=bold  ctermfg=0  ctermbg=3
" highlight DiffDelete        cterm=bold  ctermfg=0  ctermbg=1
" highlight DiffText          cterm=bold  ctermfg=1  ctermbg=11
highlight DiffAdd          cterm=bold ctermfg=15 ctermbg=2
highlight DiffChange       cterm=bold ctermfg=15 ctermbg=4
highlight DiffDelete       cterm=bold ctermfg=15 ctermbg=1
highlight DiffText                    ctermfg=8  ctermbg=3
highlight Directory                   ctermfg=14
highlight FoldColumn                  ctermfg=14 ctermbg=8
highlight Folded                      ctermfg=14 ctermbg=8
highlight SignColumn                  ctermfg=14 ctermbg=none
highlight LineNr                      ctermfg=8
highlight MoreMsg                     ctermfg=10
highlight Pmenu                       ctermfg=15 ctermbg=8
highlight PmenuSbar                              ctermbg=7
highlight PmenuSel                    ctermfg=8  ctermbg=15
highlight Question                    ctermfg=10
highlight SpellBad                    ctermfg=15 ctermbg=1
highlight StatusLineTerm              ctermfg=0  ctermbg=10
highlight StatusLineTermNC            ctermfg=0  ctermbg=10
highlight TabLine                     ctermfg=15 ctermbg=8
highlight Title                       ctermfg=13
highlight ToolbarLine                            ctermbg=8
highlight Visual                                 ctermbg=8
highlight WarningMsg                  ctermfg=9

" Conventional syntax groups
highlight Comment                 ctermfg=8
highlight Constant                ctermfg=3
highlight Error                               ctermbg=1
highlight Identifier  cterm=none  ctermfg=12
highlight PreProc                 ctermfg=14
highlight Special                 ctermfg=9
highlight SpecialKey              ctermfg=12
highlight Statement               ctermfg=10
highlight Type                    ctermfg=13
highlight Underlined              ctermfg=12

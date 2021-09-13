" Old school line length.
set textwidth=79

" Prefer C++ source files when alternating with headers.
let g:alternateExtensions_h="cpp,c,cxx,cc,CC"
let g:alternateExtensions_H="CPP,C,CXX,CC"

" Disable linting in favor of ycm's compilation behavior.
let g:ale_linters = {'cpp': []}

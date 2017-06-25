" pep 8
setlocal tabstop=4
setlocal textwidth=79

" use YCM to resolve documentation
let g:pydoc_executable=0
setlocal keywordprg=:YcmCompleter\ GetDoc

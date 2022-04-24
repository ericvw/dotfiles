" init.vim - Personal nvim configuration
" vim: nowrap:sw=4:sts=4

" User configuration that has an equivalent Lua API are factored in modules
" under the 'config' namespace.  Otherwise, it is configured via Vimscript.

" Core options
lua require("config/options")

" Key mappings
lua require("config/key-mappings")

" Autocmds
lua require("config/auto-commands")

" Local customizations

colorscheme dim-ansi

" Plugins
lua require("config/plugins")

" Language Server Protocol
lua require("config/lsp")

-- LSP plugins

return {
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")

            -- C/C++
            lspconfig.clangd.setup {}

            -- Python
            lspconfig.jedi_language_server.setup {
                init_options = {
                    completion = {
                        -- Return CompletionItem.detail in the initial
                        -- completion request to get signatures in the
                        -- completion menu because Neovim doesn"t support
                        -- "completionItem/resolve" yet to obtain this
                        -- information.
                        resolveEagerly = true,
                    },
                },
            }

            -- Rust
            lspconfig.rust_analyzer.setup {}

            -- Go
            lspconfig.gopls.setup {}

            -- Shell
            lspconfig.bashls.setup{}
        end,
    },
    {
        "ray-x/lsp_signature.nvim",
    }
}

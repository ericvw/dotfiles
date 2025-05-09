-- Language Server Protocal configuration

vim.lsp.enable({
    "bashls",
    "clangd",
    "gopls",
    "jedi_language_server",
    "rust_analyzer",
})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

        -- Enable lsp_signature plugin only when there is LSP server support.
        if client:supports_method("textDocument/signatureHelp") then
            require("lsp_signature").on_attach({}, args.buf)
        end
    end,
})

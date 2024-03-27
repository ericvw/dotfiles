-- Language Server Protocal configuration

-- Use a single letter to indicate 'complete-items' 'kind' field.
-- See :help complete-item-kind.
vim.lsp.util._get_completion_item_kind_name = function(completion_item_kind)
    return vim.lsp.protocol.CompletionItemKind[completion_item_kind]:sub(1,1):lower()
end


-- See `:help vim.diagnostic.*` for documentation on any of the below functions.
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)


-- Provide a custom `on_attach` function to configure key mapppings after the
-- language server attaches to the current buffer.
local on_attach = function(client, buffer)
    -- Enable completion triggered by <c-x><c-o>.
    vim.api.nvim_buf_set_option(buffer, "omnifunc", "v:lua.vim.lsp.omnifunc")

    -- See `:help vim.lsp.*` for documentation on any of the below functions.
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {buffer = buffer})
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, {buffer = buffer})
    vim.keymap.set("n", "K", vim.lsp.buf.hover, {buffer = buffer})
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {buffer = buffer})
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, {buffer = buffer})
    vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, {buffer = buffer})
    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, {buffer = buffer})
    vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, {buffer = buffer})
    vim.keymap.set("n", "gr", vim.lsp.buf.references, {buffer = buffer})
end


local lspconfig = require("lspconfig")

-- Common configuration that applies to all LSP servers.
local shared_lspconfig = {
    on_attach = on_attach,
}

-- C/C++
lspconfig.clangd.setup(shared_lspconfig)

-- Python
lspconfig.jedi_language_server.setup(vim.tbl_extend("error", shared_lspconfig, {
    init_options = {
        completion = {
            -- Return CompletionItem.detail in the initial completion request to get signatures in
            -- the completion menu because Neovim doesn't support "completionItem/resolve" yet to
            -- obtain this information.
            resolveEagerly = true,
        },
    },
}))

-- Rust
lspconfig.rust_analyzer.setup(shared_lspconfig)

-- Go
lspconfig.gopls.setup(shared_lspconfig)

-- Show function signatures when typing.
require("lsp_signature").setup()

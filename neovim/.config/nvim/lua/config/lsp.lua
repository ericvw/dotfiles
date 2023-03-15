-- Language Server Protocal configuration
local lsp = vim.lsp

local map = require("config.util").map

-- Use a single letter to indicate 'complete-items' 'kind' field.
-- See :help complete-item-kind.
lsp.util._get_completion_item_kind_name = function(completion_item_kind)
    return lsp.protocol.CompletionItemKind[completion_item_kind]:sub(1,1):lower()
end


-- See `:help vim.diagnostic.*` for documentation on any of the below functions.
local function nnoremap(lhs, rhs)
    map("n", lhs, rhs, { noremap = true })
end
nnoremap("<space>e", vim.diagnostic.open_float)
nnoremap("[d", vim.diagnostic.goto_prev)
nnoremap("]d", vim.diagnostic.goto_next)
nnoremap("<space>q", vim.diagnostic.setloclist)


-- Provide a custom `on_attach` function to configure key mapppings after the
-- language server attaches to the current buffer.
local on_attach = function(client, buffer)
    -- Enable completion triggered by <c-x><c-o>.
    vim.api.nvim_buf_set_option(buffer, "omnifunc", "v:lua.vim.lsp.omnifunc")

    -- See `:help vim.lsp.*` for documentation on any of the below functions.
    local function nnoremap_local(lhs, rhs)
        map("n", lhs, rhs, { noremap = true, buffer = buffer })
    end
    nnoremap_local("gD", vim.lsp.buf.declaration)
    nnoremap_local("gd", vim.lsp.buf.definition)
    nnoremap_local("K", vim.lsp.buf.hover)
    nnoremap_local("gi", vim.lsp.buf.implementation)
    nnoremap_local("<C-k>", vim.lsp.buf.signature_help)
    nnoremap_local("<space>D", vim.lsp.buf.type_definition)
    nnoremap_local("<space>rn", vim.lsp.buf.rename)
    nnoremap_local("<space>ca", vim.lsp.buf.code_action)
    nnoremap_local("gr", vim.lsp.buf.references)
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

-- Go
lspconfig.gopls.setup(shared_lspconfig)

-- Show function signatures when typing.
require("lsp_signature").setup()

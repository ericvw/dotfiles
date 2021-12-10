-- Language Server Protocal configuration

local lsp = require("vim.lsp")

-- Use a single letter to indicate 'complete-items' 'kind' field.
-- See :help complete-item-kind.
lsp.util._get_completion_item_kind_name = function(completion_item_kind)
    return lsp.protocol.CompletionItemKind[completion_item_kind]:sub(1,1):lower()
end


-- Provide a custom `on_attach` function to configure key mapppings after the
-- language server attaches to the current buffer.
local on_attach = function(client, buffer)
    local function nmap(lhs, rhs)
        vim.api.nvim_buf_set_keymap(buffer, "n", lhs, rhs, {noremap = true, silent = true})
    end
    local function set_buf_opt(...) vim.api.nvim_buf_set_option(buffer, ...) end

    -- Enable completion triggered by <c-x><c-o>.
    set_buf_opt("omnifunc", "v:lua.vim.lsp.omnifunc")

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    nmap("gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
    nmap("gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
    nmap("gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
    nmap("gr", "<cmd>lua vim.lsp.buf.references()<CR>")
    nmap("K", "<cmd>lua vim.lsp.buf.hover()<CR>")
    nmap("<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
    nmap("<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
    nmap("<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
    nmap("<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")

    nmap("<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>")
    nmap("<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>")
    nmap("[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>")
    nmap("]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>")
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

-- Show function signatures when typing.
require("lsp_signature").setup()

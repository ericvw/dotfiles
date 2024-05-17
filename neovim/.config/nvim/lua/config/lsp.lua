-- Language Server Protocal configuration
local lspconfig = require("lspconfig")

-- C/C++
lspconfig.clangd.setup {}

-- Python
lspconfig.jedi_language_server.setup {
    init_options = {
        completion = {
            -- Return CompletionItem.detail in the initial completion request to get signatures in
            -- the completion menu because Neovim doesn"t support "completionItem/resolve" yet to
            -- obtain this information.
            resolveEagerly = true,
        },
    },
}

-- Rust
lspconfig.rust_analyzer.setup {}

-- Go
lspconfig.gopls.setup {}

-- Show function signatures when typing.
require("lsp_signature").setup()

-- Use a single letter to indicate "complete-items" "kind" field.
-- See :help complete-item-kind.
vim.lsp.util._get_completion_item_kind_name = function(completion_item_kind)
    return vim.lsp.protocol.CompletionItemKind[completion_item_kind]:sub(1,1):lower()
end

-- Use LspAttach autocommand to only map the following keys after the language
-- server attaches to the current buffer.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    -- Buffer local mappings

    -- See `:help vim.lsp.*` for documentation on any of the below functions.
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<space>f", function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

-- Language Server Protocol configuration

-- Map of LSP server names to their executable commands.
local lsp_servers = {
    bashls = "bash-language-server",
    clangd = "clangd",
    gopls = "gopls",
    pyright = "pyright",
    rust_analyzer = "rust-analyzer",
}

-- Only enable servers that are available.
local available_servers = {}
for server, cmd in pairs(lsp_servers) do
    if vim.fn.executable(cmd) == 1 then
        table.insert(available_servers, server)
    end
end

if #available_servers > 0 then
    vim.lsp.enable(available_servers)
end

-- Short names for common kinds; the rest to be resolved later.
local completion_kinds = {
    Class = "cls",
    Constant = "const",
    Field = "fld",
    Function = "fn",
    Interface = "iface",
    Keyword = "key",
    Method = "meth",
    Module = "mod",
    Struct = "struct",
    Variable = "var",
}

-- Enable built-in autocompletion.
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        if client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, args.buf, {
                autotrigger = true,
                convert = function(item)
                    return {
                        -- Drop parameter lists and labelDetails from the item text.
                        abbr = (item.label:gsub("%b()", "")),
                        kind = completion_kinds[vim.lsp.protocol.CompletionItemKind[item.kind]],
                    }
                end,
            })
        end
    end,
})

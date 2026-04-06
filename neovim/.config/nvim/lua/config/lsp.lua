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

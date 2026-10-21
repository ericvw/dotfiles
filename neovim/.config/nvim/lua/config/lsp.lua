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

            vim.keymap.set("i", "<C-Space>", vim.lsp.completion.get, { buffer = args.buf })
            -- <Down>/<Up> select a candidate without inserting it.
            vim.keymap.set("i", "<C-j>", function()
                return vim.fn.pumvisible() == 1 and "<Down>" or "<C-j>"
            end, { buffer = args.buf, expr = true })
            vim.keymap.set("i", "<C-k>", function()
                return vim.fn.pumvisible() == 1 and "<Up>" or "<C-k>"
            end, { buffer = args.buf, expr = true })
            -- Accept only an explicitly selected candidate.
            vim.keymap.set("i", "<CR>", function()
                if vim.fn.complete_info({ "selected" }).selected ~= -1 then
                    return "<C-y>"
                end
                return "<CR>"
            end, { buffer = args.buf, expr = true })
        end

        if client:supports_method("textDocument/hover") then
            vim.keymap.set("n", "K", function()
                -- Pin the float to the text area so it never covers the gutter.
                local textoff = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1].textoff
                vim.lsp.buf.hover({
                    -- One column short of the edge; make_floating_popup_options
                    -- otherwise flips a full-width float to an E anchor.
                    max_width = vim.api.nvim_win_get_width(0) - textoff - 1,
                    offset_x = textoff + 1 - vim.fn.wincol(),
                })
            end, { buffer = args.buf })
        end
    end,
})

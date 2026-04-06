-- Plugins
-- vim: foldmethod=marker

-- Hooks {{{
vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == "nvim-treesitter" and (kind == "install" or kind == "update") then
            if not ev.data.active then
                vim.cmd.packadd("nvim-treesitter")
            end
            vim.cmd("TSUpdate")
        end
    end,
})
-- }}}

-- UI {{{
vim.pack.add({ "https://github.com/rebelot/kanagawa.nvim" })
vim.cmd.colorscheme("kanagawa")

vim.pack.add({ "https://github.com/nvim-lualine/lualine.nvim" })
require("lualine").setup({
    options = {
        icons_enabled = false,
        theme = "kanagawa",
    },
})
-- }}}

-- Editor {{{
vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" })
require("gitsigns").setup({})

vim.cmd.packadd("nvim.undotree")
vim.keymap.set("n", "<leader>u", vim.cmd.Undotree)

vim.pack.add({
    "https://github.com/nvim-lua/plenary.nvim",
    { src = "https://github.com/nvim-telescope/telescope.nvim", version = "v0.2.2" },
})
local builtin = require("telescope.builtin")
vim.keymap.set({ "n", "i" }, "<leader>ff", builtin.find_files)
vim.keymap.set({ "n", "i" }, "<leader>fg", builtin.git_files)
require("telescope").setup({
    defaults = {
        mappings = {
            i = {
                ["<C-j>"] = "move_selection_next",
                ["<C-k>"] = "move_selection_previous",
            },
        },
    },
})

-- Vim plugins
vim.pack.add({
    "https://github.com/tpope/vim-repeat",
    "https://github.com/tpope/vim-surround",
})
-- }}}

-- Filetype / Language Support {{{
vim.pack.add({
    "https://github.com/ericvw/vim-nim",
    "https://github.com/fladson/vim-kitty",
})
-- }}}

-- Tree-sitter {{{
vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })
-- }}}

-- LSP {{{
vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" })

vim.pack.add({ "https://github.com/ray-x/lsp_signature.nvim" })
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

        -- Enable lsp_signature plugin only when there is LSP server support.
        if client:supports_method("textDocument/signatureHelp") then
            require("lsp_signature").on_attach({}, args.buf)
        end
    end,
})
-- }}}

-- Linting {{{
vim.pack.add({ "https://github.com/mfussenegger/nvim-lint" })
local lint = require("lint")
lint.linters_by_ft = {
    python = {
        "mypy",
        "ruff",
    },
}
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    group = vim.api.nvim_create_augroup("lint", { clear = true }),
    callback = function()
        lint.try_lint()
    end,
})
-- }}

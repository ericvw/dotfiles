-- Plugins
-- vim: foldmethod=marker

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

vim.pack.add({ "https://github.com/mbbill/undotree" })
vim.keymap.set("n", "<leader>u", function()
    vim.cmd.UndotreeToggle()
end)
vim.g.undotree_SetFocusWhenToggle = true
vim.g.undotree_WindowLayout = 2

vim.pack.add({
    "https://github.com/nvim-lua/plenary.nvim",
    { src = "https://github.com/nvim-telescope/telescope.nvim", version = "v0.2.0" },
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
-- Note: Run :TSUpdate manually after first installation
-- }}}

-- LSP {{{
vim.pack.add({
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/ray-x/lsp_signature.nvim",
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

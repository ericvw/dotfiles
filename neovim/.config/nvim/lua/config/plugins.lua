-- Plugins
local map = require("config.util").map

-- Bootstrap lazy.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- Completion/LSP plugins.
    "neovim/nvim-lspconfig",
    "ray-x/lsp_signature.nvim",

    -- Behavior enhancing plugins.
    "tpope/vim-commentary",
    "tpope/vim-repeat",
    "tpope/vim-surround",

    -- IDE/UI plugins.
    "airblade/vim-gitgutter",
    "dense-analysis/ale",
    "mbbill/undotree",
    {
        "nordtheme/vim",
        name = "nordtheme",
    },
    "nvim-lualine/lualine.nvim",
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },

    -- Filetype plugins.
    "elzr/vim-json",
    "ericvw/vim-nim",
    "fladson/vim-kitty",
    "tpope/vim-git",
    "tpope/vim-markdown",
}, {
    ui = {
        icons = {
            cmd = "⌘",
            config = "🛠",
            event = "📅",
            ft = "📂",
            init = "⚙",
            keys = "🗝",
            plugin = "🔌",
            runtime = "💻",
            require = "🌙",
            source = "📄",
            start = "🚀",
            task = "📌",
            lazy = "💤 ",
        },
    },
})

-- lualine
require("lualine").setup {
    options = {
        icons_enabled = false,
        theme = "nord",
    },
}

-- UndoTree
map("n", "<leader>u", function()
    vim.cmd(":UndotreeToggle")
end)
vim.g.undotree_SetFocusWhenToggle = true
vim.g.undotree_WindowLayout = 2

-- ALE
map("n", "<leader>aj", function()
    vim.cmd(":ALENextWrap")
end)
map("n", "<leader>ak", function()
    vim.cmd(":ALEPreviousWrap")
end)

-- Telescope
require("telescope").setup {
    defaults = {
        mappings = {
            i = {
                ["<C-j>"] = "move_selection_next",
                ["<C-k>"] = "move_selection_previous"
            },
        },
    },
}

local telescope_builtin = require("telescope.builtin")
map({"n", "i"}, "<leader>ff", telescope_builtin.find_files)
map({"n", "i"}, "<leader>fg", telescope_builtin.git_files)

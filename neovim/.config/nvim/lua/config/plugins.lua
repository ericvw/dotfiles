-- Plugins

-- Bootstrap lazy.nvim.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- Completion/LSP plugins.
    "neovim/nvim-lspconfig",
    "ray-x/lsp_signature.nvim",

    -- Tree-sitter plugins.
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
    },

    -- Behavior enhancing plugins.
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

-- nvim-treesitter
require("nvim-treesitter.configs").setup {
    ensure_installed = {
        "bash",
        "c",
        "cpp",
        "fish",
        "go",
        "json",
        "lua",
        "make",
        "nim",
        "python",
        "rust",
        "toml",
        "vim",
        "vimdoc",
    },
    sync_install = #vim.api.nvim_list_uis() == 0,
}

-- lualine
require("lualine").setup {
    options = {
        icons_enabled = false,
        theme = "nord",
    },
}

-- UndoTree
vim.keymap.set("n", "<leader>u", function()
    vim.cmd.UndotreeToggle()
end)
vim.g.undotree_SetFocusWhenToggle = true
vim.g.undotree_WindowLayout = 2

-- ALE
vim.keymap.set("n", "<leader>aj", function()
    vim.cmd.ALENextWrap()
end)
vim.keymap.set("n", "<leader>ak", function()
    vim.cmd.ALEPreviousWrap()
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
vim.keymap.set({"n", "i"}, "<leader>ff", telescope_builtin.find_files)
vim.keymap.set({"n", "i"}, "<leader>fg", telescope_builtin.git_files)

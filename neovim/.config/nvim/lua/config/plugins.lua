-- Plugins
local fn = vim.fn
local opt = vim.opt

local map = require("config.util").map

-- Bootstrap packer.
local install_path = fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
    -- XXX: Manually add to the runtime path when bootstraping because the
    --      directory structure doesn't exist at Neovim startup to be
    --      automatically added.
    opt.runtimepath:prepend("/site/pack/*/start/*")
end

require('packer').startup(function()
    -- Manage packer with itself.
    use "wbthomason/packer.nvim"

    -- Completion/LSP plugins.
    use "neovim/nvim-lspconfig"
    use "ray-x/lsp_signature.nvim"

    -- Behavior enhancing plugins.
    use "editorconfig/editorconfig-vim"
    use "tpope/vim-commentary"
    use "tpope/vim-repeat"
    use "tpope/vim-surround"

    -- IDE/UI plugins.
    use "airblade/vim-gitgutter"
    use "dense-analysis/ale"
    use "itchyny/lightline.vim"
    use "mbbill/undotree"
    use {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.0",
        requires = {
            "nvim-lua/plenary.nvim",
        },
    }

    -- Filetype plugins.
    use "elzr/vim-json"
    use "tpope/vim-git"
    use "tpope/vim-markdown"

    -- XXX: Keep last to ensure configuration of above plugins.
    -- Automatically set up plugin configuration if bootstrapping packer.nvim.
    if packer_bootstrap then
        require('packer').sync()
    end
end)

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

map({"n", "i"}, "<leader>ff", require("telescope.builtin").find_files)

-- XXX: Keep this around once the dim-ansi colorscheme settles for the Diff*
--      highlight groups.
-- gitgutter's original colors
-- highlight GitGutterAdd    ctermfg=2
-- highlight GitGutterChange ctermfg=3
-- highlight GitGutterDelete ctermfg=1

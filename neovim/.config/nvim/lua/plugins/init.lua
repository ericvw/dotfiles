-- lazy.nvim plugin specification

return {
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
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },
}

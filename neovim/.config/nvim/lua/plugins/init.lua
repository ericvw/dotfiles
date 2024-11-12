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

    -- IDE/UI plugins.
    "dense-analysis/ale",
}

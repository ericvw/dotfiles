-- Tree-sitter plugins

return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.install").prefer_git = true
            require("nvim-treesitter.configs").setup({
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
            })
        end,
    },
}

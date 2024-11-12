-- Editor plugins

return {
    {
        "lewis6991/gitsigns.nvim",
        opts = {},
    },
    {
        "mbbill/undotree",
        init = function()
            vim.keymap.set("n", "<leader>u", function()
                vim.cmd.UndotreeToggle()
            end)
            vim.g.undotree_SetFocusWhenToggle = true
            vim.g.undotree_WindowLayout = 2
        end
    },
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        init = function()
            local builtin = require("telescope.builtin")
            vim.keymap.set({"n", "i"}, "<leader>ff", builtin.find_files)
            vim.keymap.set({"n", "i"}, "<leader>fg", builtin.git_files)
        end,
        opts = {
            defaults = {
                mappings = {
                    i = {
                        ["<C-j>"] = "move_selection_next",
                        ["<C-k>"] = "move_selection_previous"
                    },
                },
            },
        },
    },
    "tpope/vim-repeat",
    "tpope/vim-surround",
}

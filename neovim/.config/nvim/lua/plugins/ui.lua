-- UI plugins

return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "rebelot/kanagawa.nvim",
        },
        opts = {
            options = {
                icons_enabled = false,
                theme = "kanagawa",
            },
        },
    },
}

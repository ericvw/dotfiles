-- UI plugins

return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nordtheme",
        },
        opts = {
            options = {
                icons_enabled = false,
                theme = "nord",
            },
        }
    },
}

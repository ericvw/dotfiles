-- Color scheme plugins

return {
    {
        "nordtheme/vim",
        name = "nordtheme",
        init = function()
            vim.g.nord_italic = 1
            vim.g.nord_italic_comments = 1
            vim.g.nord_underline = 1
        end,
        config = function()
            vim.cmd.colorscheme("nord")
        end
    },
}

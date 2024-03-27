-- Use tabs instead of spaces.
vim.opt_local.expandtab = false

-- Visualize tabs taking 4 spaces.
vim.opt_local.tabstop = 4

-- Disable showing tab characters and show leading spaces.
vim.opt_local.listchars = vim.tbl_extend("force", vim.opt.listchars:get(), {
    tab = "  ",
    lead = "·",
})

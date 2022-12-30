local opt = vim.opt_local

-- Use tabs instead of spaces.
opt.expandtab = false

-- Visualize tabs taking 4 spaces.
opt.tabstop = 4

-- Disable showing tab characters and show leading spaces.
opt.listchars = vim.tbl_extend("force", vim.opt.listchars:get(), {
    tab = "  ",
    lead = "·",
})

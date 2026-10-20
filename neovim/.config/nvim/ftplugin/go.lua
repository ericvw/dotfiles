-- Hide tab markers and show leading spaces.
vim.opt_local.listchars = vim.tbl_extend("force", vim.opt.listchars:get(), {
    tab = "  ",
    lead = "·",
})

-- Key mappings

-- Disable highlight after search.
vim.keymap.set("", "<leader><space>", function()
    vim.opt.hlsearch = not vim.opt.hlsearch:get()
end)

-- Toggle spell check.
vim.keymap.set("n", "<leader>sc", function()
    vim.opt.spell = not vim.opt.spell:get()
end)

-- Strip whitespace.
vim.keymap.set("", "<leader>ss", function()
    local cursor_position = vim.fn.getpos(".")
    local old_query = vim.fn.getreg("/")
    -- TODO: Port this to Lua :substitute API if and when it exists.
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", cursor_position)
    vim.fn.setpos("/", old_query)
end)

-- Show highlighting groups for current word.
vim.keymap.set("n", "<C-N>", function()
    local syntax_items = vim.fn.synstack(vim.fn.line("."), vim.fn.col("."))
    local syntax_names = vim.tbl_map(function(syn_id)
        return vim.fn.synIDattr(syn_id, "name")
    end, syntax_items)
    vim.print(syntax_names)
end)

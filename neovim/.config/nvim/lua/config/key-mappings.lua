-- Key mappings
local fn = vim.fn
local opt = vim.opt

local map = require("config.util").map

-- Disable highlight after search.
map("", "<leader><space>", function()
    opt.hlsearch = not opt.hlsearch:get()
end)

-- Toggle spell check.
map("n", "<leader>sc", function()
    opt.spell = not opt.spell:get()
end)

-- Strip whitespace.
map("", "<leader>ss", function()
    local cursor_position = fn.getpos(".")
    local old_query = fn.getreg("/")
    -- TODO: Port this to Lua :substitute API if and when it exists.
    vim.cmd([[%s/\s\+$//e]])
    fn.setpos(".", cursor_position)
    fn.setpos("/", old_query)
end)

-- Show highlighting groups for current word.
map("n", "<C-N>", function()
    local syntax_items = fn.synstack(fn.line("."), fn.col("."))
    local syntax_names = vim.tbl_map(function(syn_id)
        return fn.synIDattr(syn_id, "name")
    end, syntax_items)
    vim.print(syntax_names)
end)

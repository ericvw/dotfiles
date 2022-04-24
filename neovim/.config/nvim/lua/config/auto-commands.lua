-- Automatic commands
local autocmd = vim.api.nvim_create_autocmd
local fn = vim.fn
local opt = vim.opt

-- Jump to the last cursor position in the file if possible.
-- TODO: :help restore-cursor uses BufRead.
--       However, &ft is not set when BufRead is triggered.
autocmd("BufEnter", {
    pattern = "*",
    callback = function(args)
        local ft = opt.filetype:get()

        local line = fn.line("'\"")
        if line >= 1 and line <= fn.line("$") and not string.find(ft, "commit") then
            fn.setpos(".", fn.getpos("'\""))
        end
    end,
    desc = "Jump to last cursor position in the file if possible",
})

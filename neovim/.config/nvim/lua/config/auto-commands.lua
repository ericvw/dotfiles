-- Automatic commands
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local fn = vim.fn
local opt = vim.opt

-- Jump to the last cursor position in the file if possible.
-- TODO: :help restore-cursor uses BufRead.
--       However, &ft is not set when BufRead is triggered, and we need to
--       workaround this unto Neovim addresses this upstream.
--       See: https://github.com/neovim/neovim/issues/15536.
local function is_within_document(line)
    return line >= 1 and line <= fn.line("$")
end

local function is_git_filetype(ft)
    return string.find(ft, "commit") or string.find(ft, "rebase")
end

local restore_cursor = augroup("RestoreCursor", {})
autocmd("BufRead", {
    group = restore_cursor,
    pattern = "*",
    callback = function(args)
        autocmd("FileType", {
            buffer = args.buffer,
            once = true,
            callback = function(args)
                local ft = opt.filetype:get()
                local line = fn.line("'\"")

                if is_within_document(line) and not is_git_filetype(ft) then
                    fn.setpos(".", fn.getpos("'\""))
                end
            end,
            desc = "Jump to last cursor position in the file if possible",
        })
    end,
    desc = "Create one shot buffer-local autocommand to restore cursor",
})

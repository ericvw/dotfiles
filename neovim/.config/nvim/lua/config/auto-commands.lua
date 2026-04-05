-- Automatic commands

-- Jump to the last cursor position in the file if possible.
-- TODO: :help restore-cursor uses BufRead.
--       However, &ft is not set when BufRead is triggered, and we need to
--       workaround this unto Neovim addresses this upstream.
--       See: https://github.com/neovim/neovim/issues/15536.
local function is_within_document(line)
    return line >= 1 and line <= vim.fn.line("$")
end

local function should_skip_restore(buf)
    local ft = vim.bo[buf].filetype

    return string.find(ft, "commit") or ft == "gitrebase" or ft == "xxd" or vim.wo.diff
end

local restore_cursor = vim.api.nvim_create_augroup("RestoreCursor", {})
vim.api.nvim_create_autocmd("BufRead", {
    group = restore_cursor,
    pattern = "*",
    callback = function(args)
        vim.api.nvim_create_autocmd("FileType", {
            buffer = args.buf,
            once = true,
            callback = function(args)
                local line = vim.fn.line("'\"")

                if is_within_document(line) and not should_skip_restore(args.buf) then
                    vim.fn.setpos(".", vim.fn.getpos("'\""))
                end
            end,
            desc = "Jump to last cursor position in the file if possible",
        })
    end,
    desc = "Create one shot buffer-local autocommand to restore cursor",
})

-- Automatically close preview window after Insert mode completion is done.
vim.api.nvim_create_autocmd("CompleteDone", {
    callback = function(args)
        vim.cmd.pclose()
    end,
})

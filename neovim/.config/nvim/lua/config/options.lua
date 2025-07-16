-- Initialization options grouped by function.
-- Run :options to understand grouping of settings.

-- 2 moving around, searching and patterns
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- 4 displaying text
vim.opt.scrolloff = 1
vim.opt.lazyredraw = true
vim.opt.list = true
vim.opt.listchars = {
    tab = "» ",
    trail = "·",
    extends = ">",
    precedes = "<",
}
vim.opt.number = true

-- 5 syntax, highlighting and spelling
vim.opt.colorcolumn = "+1"

-- 6 multiple windows
vim.opt.splitright = true
vim.opt.splitbelow = true

-- 9 using the mouse
vim.opt.mouse = "a"

-- 11 message and info
vim.opt.shortmess:append({
    a = true,
    I = true,
})
vim.opt.report = 0
vim.opt.errorbells = false

-- 13 editing text
vim.opt.undofile = true
vim.opt.completeopt = {
    "fuzzy",
    "menu",
    "menuone",
    "noselect",
    "preview",
}
vim.opt.showmatch = true

-- 14 tabs and indenting
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.shiftround = true
vim.opt.expandtab = true
vim.opt.cinoptions = {
    ":0.5s", -- placement of case after switch statement
    "=0.5s", -- place statements after case label
    "l1",    -- align with case label instead of statement
    "g0.5s", -- place C++ scope declarations
    "h0.5s", -- places statements after C++ scope decls
    "N-s",   -- indent inside C++ namespace
    "t0",    -- indent function return type at margin
    "i0",    -- C++ base class decls and initializations
    "(0",    -- indent from unclosed parens
    "J1",    -- don't confuse JS object decls with labels
}

-- 18 reading and writing files
vim.opt.bomb = false
vim.opt.fileformats:append("mac")
vim.opt.backup = true
vim.opt.backupdir:remove(".")
for i,v in ipairs(vim.opt.backupdir:get()) do
    local d = vim.fn.expand(v)
    if vim.fn.isdirectory(d) == 0 then
        vim.fn.mkdir(d, "p")
    end
end

-- 20 command line editing
vim.opt.wildmode = {
    "list:longest",
    "full"
}
vim.opt.wildignore:append({
    "*.pyc", -- Python byte codes.
    "*.o", -- Compiled object files.
})

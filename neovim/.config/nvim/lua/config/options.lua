-- Initialization options grouped by function.
-- Run :options to understand grouping of settings.
local fn = vim.fn
local opt = vim.opt

-- 1 important
opt.pastetoggle = "<F2>"

-- 2 moving around, searching and patterns
opt.ignorecase = true
opt.smartcase = true

-- 4 displaying text
opt.scrolloff = 1
opt.lazyredraw = true
opt.list = true
opt.listchars = {
    tab = "» ",
    trail = "·",
    extends = ">",
    precedes = "<",
}
opt.number = true

-- 5 syntax, highlighting and spelling
opt.colorcolumn = "+1"

-- 6 multiple windows
opt.splitright = true
opt.splitbelow = true

-- 9 using the mouse
opt.mouse = "a"

-- 11 message and info
opt.shortmess:append({
    a = true,
    I = true,
})
opt.report = 0
opt.errorbells = false

-- 13 editing text
opt.undofile = true
opt.showmatch = true

-- 14 tabs and indenting
opt.shiftwidth = 4
opt.softtabstop = 4
opt.shiftround = true
opt.expandtab = true
opt.cinoptions = {
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
opt.bomb = false
opt.fileformats:append("mac")
opt.backup = true
opt.backupdir:remove(".")
for i,v in ipairs(opt.backupdir:get()) do
    local d = fn.expand(v)
    if fn.isdirectory(d) == 0 then
        fn.mkdir(d, "p")
    end
end

-- 20 command line editing
opt.wildmode = {
    "list:longest",
    "full"
}
opt.wildignore:append({
    "*.pyc", -- Python byte codes.
    "*.o", -- Compiled object files.
})

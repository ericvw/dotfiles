-- Platform-specific configuration

-- Windows Subsystem for Linux configuration
if vim.fn.has("wsl") == 1 then
    -- Use the Lua equivalent of `h: clipboard-wsl` to communicate with the
    -- Windows clipboard.
    vim.g.clipboard = {
        name = "WslClipboard",
        copy = {
            ["+"] = "clip.exe",
            ["*"] = "clip.exe",
        },
        paste = {
            ["+"] = "powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace('`r', ''))",
            ["*"] = "powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace('`r', ''))",
        },
        cache_enabled = 0,
    }
end

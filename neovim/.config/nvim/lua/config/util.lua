-- Shared functionality for configuration

local module = {}

module.map = function(mode, lhs, rhs, opts)
    opts = opts or {}
    opts["silent"] = opts["silent"] or true
    vim.keymap.set(mode, lhs, rhs, opts)
end

return module

-- init.lua - Personal nvim configuration
-- vim: nowrap:sw=4:sts=4

-- Core options
require("config.options")

-- Plugins
require("config.plugins")

-- Key mappings
require("config.key-mappings")

-- Auto commands
require("config.auto-commands")

-- Language Server Protocol
require("config.lsp")

-- Local customizations
require("config.color-scheme")

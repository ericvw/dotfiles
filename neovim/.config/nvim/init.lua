-- init.lua - Personal nvim configuration
-- vim: nowrap:sw=4:sts=4

-- Core options
require("config.options")

-- Platform-specific configuration
require("config.platform")

-- Key mappings
require("config.key-mappings")

-- Auto commands
require("config.auto-commands")

-- Plugins
require("config.plugins")

-- Language Server Protocol
require("config.lsp")

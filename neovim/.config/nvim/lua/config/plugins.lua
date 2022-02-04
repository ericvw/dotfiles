-- Plugins
local fn = vim.fn
local opt = vim.opt

-- Bootstrap packer.
local install_path = fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
    -- XXX: Manually add to the runtime path when bootstraping because the
    --      directory structure doesn't exist at Neovim startup to be
    --      automatically added.
    opt.runtimepath:prepend("/site/pack/*/start/*")
end

return require('packer').startup(function()
    -- Manage packer with itself.
    use "wbthomason/packer.nvim"

    -- Completion related plugins.
    use "neovim/nvim-lspconfig"
    use "ray-x/lsp_signature.nvim"

    -- XXX: Keep last to ensure configuration of above plugins.
    -- Automatically set up plugin configuration if bootstrapping packer.nvim.
    if packer_bootstrap then
        require('packer').sync()
    end
end)

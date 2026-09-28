-- ============================================================================
-- Entry Point
-- ============================================================================

-- Enable faster startup by caching compiled Lua bytecode
vim.loader.enable()

-- Set leader keys before loading any plugin
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- Helper for GitHub plugin URLs
_G.gh = function(repo)
return 'https://github.com/' .. repo
end

-- Core configuration
require('config.options')
require('config.keymaps')
require('config.autocmds')

-- Plugin configurations
require('plugins.ui')
require('plugins.mini')
require('plugins.explorer')
require('plugins.coding')
require('plugins.telescope')
require('plugins.treesitter')
require('plugins.lsp')
require('plugins.completion')
require('plugins.formatting')
require('plugins.linting')
require('plugins.dap')

-- ============================================================================
-- Core Options & Editor Settings
-- ============================================================================

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Mouse & Mode
vim.o.mouse = 'a'
vim.o.showmode = false

-- Clipboard (defer to avoid startup delay)
vim.schedule(function()
vim.o.clipboard = 'unnamedplus'
end)

-- Indentation & Wrapping
vim.o.breakindent = true
vim.o.undofile = true

-- Search settings
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.inccommand = 'split'

-- Gutter & Signs
vim.o.signcolumn = 'yes'
vim.o.cursorline = true
vim.opt.colorcolumn = { '80', '100' }

-- Performance & Timings
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Window splits & Scrolloff
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.scrolloff = 10

-- Whitespace rendering
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Dialog confirmation on quit with unsaved changes
vim.o.confirm = true

-- Global Statusline
vim.o.laststatus = 3

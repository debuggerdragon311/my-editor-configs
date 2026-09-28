-- ============================================================================
-- Keymaps & Diagnostics
-- ============================================================================

-- Clear search highlight on Esc
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic Configuration
vim.diagnostic.config({
    update_in_insert = false,
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = { min = vim.diagnostic.severity.WARN } },
    virtual_text = true,
    virtual_lines = false,
    jump = {
        on_jump = function(_, bufnr)
        vim.diagnostic.open_float({ bufnr = bufnr, scope = 'cursor', focus = false })
        end,
    },
})

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Terminal mode exit
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Window split navigation
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus left' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus right' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus lower' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus upper' })

-- File Explorer (Neo-tree)
vim.keymap.set('n', '<C-S-e>', '<cmd>Neotree toggle<CR>', { desc = 'Toggle File Explorer' })
vim.keymap.set('n', '<C-S-E>', '<cmd>Neotree toggle<CR>', { desc = 'Toggle File Explorer' })
vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle<CR>', { desc = 'Toggle File [E]xplorer' })
vim.keymap.set('n', '\\', '<cmd>Neotree reveal<CR>', { desc = 'NeoTree reveal', silent = true })

-- Buffer / Tab navigation
vim.keymap.set('n', '<S-h>', '<cmd>bprevious<CR>', { desc = 'Previous Tab (Buffer)' })
vim.keymap.set('n', '<S-l>', '<cmd>bnext<CR>', { desc = 'Next Tab (Buffer)' })
vim.keymap.set('n', '<leader>c', '<cmd>bdelete<CR>', { desc = '[C]lose current tab' })

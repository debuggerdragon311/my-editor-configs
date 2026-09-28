-- ============================================================================
-- File Explorers: Neo-tree & mini.files
-- ============================================================================

-- Neo-tree setup
vim.pack.add({
    { src = gh('nvim-neo-tree/neo-tree.nvim'), version = vim.version.range('3') },
             gh('nvim-lua/plenary.nvim'),
             gh('MunifTanjim/nui.nvim'),
             gh('nvim-tree/nvim-web-devicons'),
})

require('neo-tree').setup({
    close_if_last_window = true,
    window = {
        position = 'left',
        width = 35,
    },
    filesystem = {
        window = {
            mappings = {
                ['\\'] = 'close_window',
            },
        },
    },
})

-- mini.files setup
require('mini.files').setup({
    windows = {
        preview = true,
        width_focus = 30,
        width_preview = 30,
    },
})

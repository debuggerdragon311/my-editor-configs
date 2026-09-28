-- ============================================================================
-- Coding Utilities: Gitsigns, Autopairs, Indent lines, Todo Comments
-- ============================================================================

vim.pack.add({
  gh('NMAC427/guess-indent.nvim'),
  gh('lewis6991/gitsigns.nvim'),
  gh('folke/todo-comments.nvim'),
  gh('windwp/nvim-autopairs'),
  gh('lukas-reineke/indent-blankline.nvim'),
})

-- Indent detection
require('guess-indent').setup({})

-- Autopairs
require('nvim-autopairs').setup({})

-- Indent Blankline
require('ibl').setup({})

-- Todo comments
require('todo-comments').setup({ signs = false })

-- Gitsigns
require('gitsigns').setup({
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
  on_attach = function(bufnr)
    local gs = require('gitsigns')
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then vim.cmd.normal({ ']c', bang = true }) else gs.nav_hunk('next') end
    end, { desc = 'Jump to next git change' })

    map('n', '[c', function()
      if vim.wo.diff then vim.cmd.normal({ '[c', bang = true }) else gs.nav_hunk('prev') end
    end, { desc = 'Jump to previous git change' })

    -- Hunk actions
    map('v', '<leader>hs', function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, { desc = 'git [s]tage hunk' })
    map('v', '<leader>hr', function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, { desc = 'git [r]eset hunk' })
    map('n', '<leader>hs', gs.stage_hunk, { desc = 'git [s]tage hunk' })
    map('n', '<leader>hr', gs.reset_hunk, { desc = 'git [r]eset hunk' })
    map('n', '<leader>hS', gs.stage_buffer, { desc = 'git [S]tage buffer' })
    map('n', '<leader>hR', gs.reset_buffer, { desc = 'git [R]eset buffer' })
    map('n', '<leader>hp', gs.preview_hunk, { desc = 'git [p]review hunk' })
    map('n', '<leader>hi', gs.preview_hunk_inline, { desc = 'git preview hunk [i]nline' })
    map('n', '<leader>hb', function() gs.blame_line({ full = true }) end, { desc = 'git [b]lame line' })
    map('n', '<leader>hd', gs.diffthis, { desc = 'git [d]iff against index' })
    map('n', '<leader>hD', function() gs.diffthis('@') end, { desc = 'git [D]iff against last commit' })
    map('n', '<leader>hQ', function() gs.setqflist('all') end, { desc = 'git hunk [Q]uickfix list (all)' })
    map('n', '<leader>hq', gs.setqflist, { desc = 'git hunk [q]uickfix list (file)' })

    -- Toggles
    map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = '[T]oggle git [b]lame line' })
    map('n', '<leader>tw', gs.toggle_word_diff, { desc = '[T]oggle git [w]ord diff' })

    -- Text object
    map({ 'o', 'x' }, 'ih', gs.select_hunk)
  end,
})

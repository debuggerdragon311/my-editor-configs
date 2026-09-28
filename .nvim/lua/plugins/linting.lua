-- ============================================================================
-- Linter (nvim-lint)
-- ============================================================================

vim.pack.add({ gh('mfussenegger/nvim-lint') })

local lint = require('lint')
lint.linters_by_ft = {
  markdown = { 'markdownlint' },
}

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
  group = vim.api.nvim_create_augroup('user-lint', { clear = true }),
  callback = function()
    if vim.bo.modifiable then
      lint.try_lint()
    end
  end,
})

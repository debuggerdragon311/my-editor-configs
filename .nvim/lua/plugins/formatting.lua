-- ============================================================================
-- Code Formatting (Conform.nvim)
-- ============================================================================

vim.pack.add({ gh('stevearc/conform.nvim') })

require('conform').setup({
    notify_on_error = false,
    format_on_save = function(bufnr)
        local enabled_filetypes = {}
        return enabled_filetypes[vim.bo[bufnr].filetype] and { timeout_ms = 500 } or nil
        end,
        default_format_opts = {
            lsp_format = 'fallback',
        },
        formatters_by_ft = {},
})

vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
require('conform').format({ async = true })
end, { desc = '[F]ormat buffer' })

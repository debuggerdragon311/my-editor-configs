-- ============================================================================
-- Autocompletion (Blink.cmp) & Snippets (LuaSnip)
-- ============================================================================

vim.pack.add({
    { src = gh('L3MON4D3/LuaSnip'), version = vim.version.range('2.*') },
             { src = gh('saghen/blink.cmp'), version = vim.version.range('1.*') },
})

require('luasnip').setup({})

require('blink.cmp').setup({
    keymap = { preset = 'default' },
    appearance = { nerd_font_variant = 'mono' },
    completion = {
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
    },
    sources = {
        default = { 'lsp', 'path', 'snippets' },
    },
    snippets = { preset = 'luasnip' },
    fuzzy = { implementation = 'lua' },
    signature = { enabled = true },
})

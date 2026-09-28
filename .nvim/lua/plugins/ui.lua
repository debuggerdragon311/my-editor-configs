-- ============================================================================
-- UI Plugins: Themes, Tabs, Keybind Helper & Dashboard
-- ============================================================================

-- [[ 1. Doom One Colorscheme ]]
vim.pack.add({ { src = gh('NTBBloodbath/doom-one.nvim'), name = 'doom-one' } })
vim.g.doom_one_italic_comments = true
vim.g.doom_one_transparent_background = false
vim.g.doom_one_terminal_colors = true
vim.cmd.colorscheme('doom-one')

-- [[ 2. Which-Key ]]
vim.pack.add({ gh('folke/which-key.nvim') })
require('which-key').setup({
  delay = 0,
  icons = { mappings = vim.g.have_nerd_font },
  spec = {
    { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
    { '<leader>t', group = '[T]oggle' },
    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
    { '<leader>e', desc = 'Toggle File [E]xplorer' },
    { 'gr', group = 'LSP Actions', mode = { 'n' } },
  },
})

-- [[ 3. Bufferline ]]
vim.pack.add({ { src = gh('akinsho/bufferline.nvim'), version = vim.version.range('*') } })
require('bufferline').setup({
  options = {
    mode = 'buffers',
    separator_style = 'thin',
    style_preset = require('bufferline').style_preset.default,
    close_command = 'bdelete! %d',
    right_mouse_command = 'bdelete! %d',
    left_mouse_command = 'buffer %d',
    buffer_close_icon = ' 󰅖',
    modified_icon = ' ●',
    close_icon = '',
    show_buffer_close_icons = true,
    show_close_icon = false,
    indicator = { style = 'underline' },
    diagnostics = 'nvim_lsp',
    diagnostics_indicator = function(count, level)
      local icon = level:match('error') and '  ' or '  '
      return icon .. count
    end,
    offsets = {
      {
        filetype = 'neo-tree',
        text = '  FILE EXPLORER',
        text_align = 'center',
        highlight = 'Directory',
        separator = true,
      },
    },
  },
})

-- [[ 4. Alpha Dashboard ]]
pcall(vim.pack.add, { gh('goolord/alpha-nvim'), gh('nvim-tree/nvim-web-devicons') })
local ok_alpha, alpha = pcall(require, 'alpha')
if ok_alpha then
  local dashboard = require('alpha.themes.dashboard')

  vim.api.nvim_set_hl(0, 'NvimLogo', { fg = '#5FB3A1', bold = true })
  vim.api.nvim_set_hl(0, 'NvimButton', { fg = '#7aa2f7' })
  vim.api.nvim_set_hl(0, 'NvimFooter', { fg = '#565f89', italic = true })

  dashboard.section.header.val = {
    [[   ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗   ]],
    [[   ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║   ]],
    [[   ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║   ]],
    [[   ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║   ]],
    [[   ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║   ]],
    [[   ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝   ]],
  }
  dashboard.section.header.opts.hl = 'NvimLogo'

  dashboard.section.buttons.val = {
    dashboard.button('f', '  Find file', ':Telescope find_files <CR>'),
    dashboard.button('r', '  Recent files', ':Telescope oldfiles <CR>'),
    dashboard.button('e', '  New file', ':ene <BAR> startinsert <CR>'),
    dashboard.button('g', '  Find text', ':Telescope live_grep <CR>'),
    dashboard.button('c', '  Config', ':e $MYVIMRC <CR>'),
    dashboard.button('q', '  Quit', ':qa<CR>'),
  }
  dashboard.section.buttons.opts.hl = 'NvimButton'
  dashboard.section.buttons.opts.width = 20
  dashboard.section.buttons.opts.spacing = 1

  dashboard.section.footer.val = 'Copyright © 2017 Soumyajit Bala. All Rights Reserved.'
  dashboard.section.footer.opts.hl = 'NvimFooter'

  local function get_top_padding()
    local header_h = #dashboard.section.header.val
    local buttons_h = #dashboard.section.buttons.val
    local total_content_h = header_h + buttons_h + 6
    local win_h = vim.api.nvim_win_get_height(0)
    return math.max(math.floor((win_h - total_content_h) / 2), 1)
  end

  dashboard.config.layout = {
    { type = 'padding', val = get_top_padding() },
    dashboard.section.header,
    { type = 'padding', val = 1 },
    dashboard.section.buttons,
    { type = 'padding', val = 1 },
    dashboard.section.footer,
  }

  alpha.setup(dashboard.opts)
end

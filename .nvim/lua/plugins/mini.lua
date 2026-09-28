-- ============================================================================
-- mini.nvim: Icons, Textobjects, Surrounds & Custom Powerline Statusline
-- ============================================================================

vim.pack.add({ gh('nvim-mini/mini.nvim') })

-- Mini Icons
if vim.g.have_nerd_font then
  require('mini.icons').setup()
  MiniIcons.mock_nvim_web_devicons()
end

-- Mini AI & Surround
require('mini.ai').setup({
  mappings = { around_next = 'aa', inside_next = 'ii' },
  n_lines = 500,
})
require('mini.surround').setup()

-- [[ Statusline Setup ]]
local icon_hl_cache = {}

local function setup_statusline_highlights()
  icon_hl_cache = {}
  local bar_bg = vim.api.nvim_get_hl(0, { name = 'MiniStatuslineFilename', link = false }).bg
    or vim.api.nvim_get_hl(0, { name = 'StatusLine', link = false }).bg
    or '#21242b'
  local comment_fg = vim.api.nvim_get_hl(0, { name = 'Comment', link = false }).fg

  -- Mode badge colors
  local dark_text = '#1c1f24'
  local mode_colors = {
    MiniStatuslineModeNormal = { bg = '#51afef', fg = dark_text },
    MiniStatuslineModeInsert = { bg = '#98be65', fg = dark_text },
    MiniStatuslineModeVisual = { bg = '#c678dd', fg = dark_text },
    MiniStatuslineModeReplace = { bg = '#ff6c6b', fg = dark_text },
    MiniStatuslineModeCommand = { bg = '#ecbe7b', fg = dark_text },
    MiniStatuslineModeOther = { bg = '#46D9FF', fg = dark_text },
  }

  for hl_name, colors in pairs(mode_colors) do
    vim.api.nvim_set_hl(0, hl_name, { bg = colors.bg, fg = colors.fg, bold = true })
  end

  if comment_fg and bar_bg then
    vim.api.nvim_set_hl(0, 'MiniStatuslineDim', { fg = '#5c6370', bg = bar_bg })
  end

  if bar_bg then
    vim.api.nvim_set_hl(0, 'MiniStatuslineOS_unix', { fg = '#e0af68', bg = bar_bg })
    vim.api.nvim_set_hl(0, 'MiniStatuslineOS_dos', { fg = '#7dcfff', bg = bar_bg })
    vim.api.nvim_set_hl(0, 'MiniStatuslineOS_mac', { fg = '#c0caf5', bg = bar_bg })
    vim.api.nvim_set_hl(0, 'MiniStatuslineLSPIcon', { fg = '#46D9FF', bg = bar_bg })
  end
end

vim.api.nvim_create_autocmd('ColorScheme', { callback = setup_statusline_highlights })
setup_statusline_highlights()

local function get_colored_icon(category, name, base_hl)
  if not vim.g.have_nerd_font then return '' end
  local icon, icon_hl = require('mini.icons').get(category, name)
  if not icon then return '' end
  if not icon_hl then return icon .. ' ' end

  local custom_hl = base_hl .. '_' .. icon_hl
  if not icon_hl_cache[custom_hl] then
    local icon_def = vim.api.nvim_get_hl(0, { name = icon_hl, link = false })
    local base_def = vim.api.nvim_get_hl(0, { name = base_hl, link = false })
    if icon_def.fg and base_def.bg then
      vim.api.nvim_set_hl(0, custom_hl, { fg = icon_def.fg, bg = base_def.bg })
      icon_hl_cache[custom_hl] = true
    end
  end

  return icon_hl_cache[custom_hl] and string.format('%%#%s#%s%%#%s# ', custom_hl, icon, base_hl) or (icon .. ' ')
end

local function get_transition_hls(mode_hl)
  local mode_def = vim.api.nvim_get_hl(0, { name = mode_hl, link = false })
  local bar_def = vim.api.nvim_get_hl(0, { name = 'MiniStatuslineFilename', link = false })
  local mode_bg = mode_def.bg or mode_def.fg
  local bar_bg = bar_def.bg or vim.api.nvim_get_hl(0, { name = 'StatusLine', link = false }).bg or '#21242b'

  local trans_l, trans_r = 'MiniStatuslineTransL_' .. mode_hl, 'MiniStatuslineTransR_' .. mode_hl
  if mode_bg and bar_bg then
    vim.api.nvim_set_hl(0, trans_l, { fg = mode_bg, bg = bar_bg })
    vim.api.nvim_set_hl(0, trans_r, { fg = mode_bg, bg = bar_bg })
  end
  return trans_l, trans_r
end

local statusline = require('mini.statusline')
statusline.setup({
  use_icons = vim.g.have_nerd_font,
  content = {
    active = function()
      local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
      local trans_l_hl, trans_r_hl = get_transition_hls(mode_hl)

      local git = statusline.section_git({ trunc_width = 40 })
      local diff = statusline.section_diff({ trunc_width = 75 })
      local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
      local devinfo = table.concat(vim.tbl_filter(function(v) return v ~= '' end, { git, diff, diagnostics }), ' ')
      if devinfo ~= '' then devinfo = ' ' .. devinfo .. ' ' end

      -- 1. File icon + name
      local filename = vim.fn.expand('%:t')
      if filename == '' then filename = '[No Name]' end
      local file_icon = get_colored_icon('file', filename, 'MiniStatuslineFilename')
      local modified = vim.bo.modified and ' ●' or (vim.bo.modifiable == false and ' 󰌾' or '')
      local file_section = ' ' .. file_icon .. filename .. modified

      -- 2. Active LSP Servers
      local lsp = ''
      local ft = vim.bo.filetype
      local ft_dim = ft ~= '' and string.format('%%#MiniStatuslineDim#(%s)%%#MiniStatuslineFilename#', ft) or ''
      local clients = vim.lsp.get_clients({ bufnr = 0 })

      if #clients > 0 then
        local names = vim.tbl_map(function(c) return c.name end, clients)
        lsp = '%#MiniStatuslineLSPIcon#󰒋%#MiniStatuslineFilename# ' .. table.concat(names, ', ')
        if ft_dim ~= '' then lsp = lsp .. ' ' .. ft_dim end
      elseif ft_dim ~= '' then
        lsp = ft_dim
      end

      -- 3. File Info & OS
      local enc = (vim.bo.fileencoding ~= '' and vim.bo.fileencoding or vim.o.encoding):upper()
      local os_icons = {
        unix = '%#MiniStatuslineOS_unix#%#MiniStatuslineFilename#',
        dos = '%#MiniStatuslineOS_dos#%#MiniStatuslineFilename#',
        mac = '%#MiniStatuslineOS_mac#%#MiniStatuslineFilename#',
      }
      local format_str = string.format('%s %s', os_icons[vim.bo.fileformat] or vim.bo.fileformat, enc)

      local size = ''
      local bytes = vim.fn.getfsize(vim.fn.expand('%'))
      if bytes > 0 then
        if bytes < 1024 then
          size = bytes .. 'B'
        elseif bytes < 1024 * 1024 then
          size = string.format('%.1fK', bytes / 1024)
        else
          size = string.format('%.1fM', bytes / (1024 * 1024))
        end
      end

      local right_items = {}
      if lsp ~= '' then table.insert(right_items, lsp) end
      if format_str ~= '' then table.insert(right_items, format_str) end
      if size ~= '' then table.insert(right_items, size) end
      local right_section = table.concat(right_items, '  ')
      if right_section ~= '' then right_section = right_section .. ' ' end

      -- 4. Location & Progress
      local location = '󰍎 %l:%-2v  %p%%'

      return table.concat({
        '%#', mode_hl, '# ', mode, ' ',
        '%#', trans_l_hl, '#',
        '%#MiniStatuslineFilename#', devinfo, file_section,
        '%=',
        '%#MiniStatuslineFilename#', right_section,
        '%#', trans_r_hl, '#',
        '%#', mode_hl, '# ', location, ' ',
      })
    end,
  },
})

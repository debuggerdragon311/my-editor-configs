-- ============================================================================
-- LSP (Language Server Protocol) & Mason Configuration
-- ============================================================================

vim.pack.add({
  gh('j-hui/fidget.nvim'),
  gh('neovim/nvim-lspconfig'),
  gh('mason-org/mason.nvim'),
  gh('mason-org/mason-lspconfig.nvim'),
  gh('WhoIsSethDaniel/mason-tool-installer.nvim'),
})

require('fidget').setup({})

-- Autocmd on LSP Attach
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('user-lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      vim.keymap.set(mode or 'n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
    map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
    map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    local client = vim.lsp.get_client_by_id(event.data.client_id)

    -- Document highlight on hover
    if client and client:supports_method('textDocument/documentHighlight', event.buf) then
      local highlight_group = vim.api.nvim_create_augroup('user-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_group,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_group,
        callback = vim.lsp.buf.clear_references,
      })
      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('user-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = 'user-lsp-highlight', buffer = event2.buf })
        end,
      })
    end

    -- Inlay Hints
    if client and client:supports_method('textDocument/inlayHint', event.buf) then
      vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }), { bufnr = event.buf })
      end, '[T]oggle Inlay [H]ints')
    end
  end,
})

-- Server Configurations
local servers = {
  jdtls = {
    cmd = function(dispatchers)
      local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
      local workspace_dir = vim.fn.stdpath('data') .. '/jdtls-workspaces/' .. project_name
      local jdtls_bin = vim.fn.stdpath('data') .. '/mason/bin/jdtls'
      local cmd = {
        vim.fn.executable(jdtls_bin) == 1 and jdtls_bin or 'jdtls',
        '-data',
        workspace_dir,
      }
      return vim.lsp.rpc.start(cmd, dispatchers)
    end,
    root_markers = { 'pom.xml', 'build.gradle', '.git', 'mvnw', 'gradlew' },
    single_file_support = true,
    settings = {
      java = {
        signatureHelp = { enabled = true },
        contentProvider = { preferred = 'fernflower' },
        eclipse = { downloadSources = true },
        maven = { downloadSources = true },
        inlayHints = { parameterNames = { enabled = 'all', exclusions = { 'this' } } },
        sources = { organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 } },
      },
    },
  },

  clangd = {
    cmd = {
      'clangd',
      '--background-index',
      '--clang-tidy',
      '--header-insertion=iwyu',
      '--completion-style=detailed',
      '--function-arg-placeholders',
      '--fallback-style=llvm',
    },
  },

  zls = {
    cmd = { 'zls' },
    settings = {
      zls = {
        zig_exe_path = '/home/sbala/projects/zig/zig-dist/zig',
        zig_lib_path = '/home/sbala/projects/zig/zig-dist/lib',
        enable_autofix = true,
        enable_snippets = true,
        enable_inlay_hints = true,
        inlay_hints_show_builtin = true,
        inlay_hints_exclude_single_argument = true,
        inlay_hints_hide_redundant_param_names = true,
      },
    },
  },

  lua_ls = {
    on_init = function(client)
      client.server_capabilities.documentFormattingProvider = false
      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if path ~= vim.fn.stdpath('config') and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
          return
        end
      end
      client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = { version = 'LuaJIT', path = { 'lua/?.lua', 'lua/?/init.lua' } },
        workspace = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file('', true) },
      })
    end,
    settings = {
      Lua = {
        format = { enable = false },
        hint = {
          enable = true,
          setType = true,
          paramType = true,
          paramName = 'Literal',
          semicolon = 'Disable',
          arrayIndex = 'Disable',
        },
      },
    },
  },
}

-- Mason Setup
require('mason').setup({})
require('mason-lspconfig').setup({ automatic_enable = false })

-- Auto-install LSPs and formatters
local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, { 'stylua' })

local has_installer, tool_installer = pcall(require, 'mason-tool-installer')
if has_installer then
  tool_installer.setup({ ensure_installed = ensure_installed })
end

-- Enable Language Servers
for name, server in pairs(servers) do
  vim.lsp.config(name, server)
  vim.lsp.enable(name)
end

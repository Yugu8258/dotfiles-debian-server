require 'keymaps'
require 'settings'
require 'plugins'
require 'ui'
require 'tools'
require 'edit'
require 'snippets'

vim.lsp.enable({
  'clangd',
  'lua_ls',
  'ruff',
  'rust_analyzer',
  'ty',
})

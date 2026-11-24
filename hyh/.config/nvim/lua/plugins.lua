-- Using the built-in plugin manager. See `:help vim.pack`.
-- Update with `:lua vim.pack.update()`.

vim.pack.add {
  'https://github.com/Shatur/neovim-ayu', 
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/christoomey/vim-tmux-navigator',
}

-- Treesitter. Neovim only bundles parsers for c, lua, markdown, vim, vimdoc and
-- query; nvim-treesitter installs the rest. Needs `tree-sitter` CLI and a C compiler.
-- See `:help treesitter-highlight` and `:checkhealth nvim-treesitter`
local ts_langs = { 'bash', 'make', 'python' }
require('nvim-treesitter').install(ts_langs)
vim.api.nvim_create_autocmd('PackChanged', {
  desc = 'Update parsers when nvim-treesitter is updated',
  group = vim.api.nvim_create_augroup('user-ts-update', { clear = true }),
  callback = function(ev)
    if ev.data.spec.name == 'nvim-treesitter' and ev.data.kind == 'update' then
      vim.cmd 'TSUpdate'
    end
  end,
})

-- Only for the languages above: c's regex syntax plus clangd's semantic tokens looks
-- just as good, without the flicker of the async first parse
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Use treesitter highlighting for the installed parsers',
  group = vim.api.nvim_create_augroup('user-ts-start', { clear = true }),
  pattern = vim.iter(ts_langs):map(vim.treesitter.language.get_filetypes):flatten()
  :totable(),
  callback = function() vim.treesitter.start() end,
})

-- Colorscheme. `ayu mirage`
require('ayu').setup {
  mirage = true,
  overrides = {
    Normal = { bg = "None" },
    NormalFloat = { bg = "None" },
    SignColumn = { bg = "None" },
  },
}
vim.cmd.colorscheme 'ayu'

-- Minimal file explorer. See `:help oil`
require('oil').setup({
  delete_to_trash = false,
  skip_confirm_for_simple_edits = true,
  constrain_cursor = "editable",
  view_options = {
    show_hidden = true,
  },
})
vim.keymap.set('n', '<leader>-', '<cmd>Oil<CR>', { desc = 'Open parent directory' })

-- Git added/changed/deleted lines in the sign column. See `:help gitsigns`
require('gitsigns').setup()

-- Telescope, see `:help telescope`
require('telescope').setup()
local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>ff', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers,
  { desc = 'Find existing buffers' })
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sm', function()
  -- Sections 2 (system calls) and 3 (C library functions)
  local opts = { sections = { '2', '3' } }
  -- Match on every name of a page (e.g. "calloc, free, malloc"), not just the first
  local make_entry = require('telescope.make_entry').gen_from_apropos(opts)
  opts.entry_maker = function(line)
    local entry = make_entry(line)
    if entry then
      entry.ordinal = entry.keyword
    end
    return entry
  end
  builtin.man_pages(opts)
end, { desc = '[S]earch [M]an pages' })

-- ========== vim-tmux-navigator keymaps ==========
vim.keymap.set('n', '<C-h>', '<cmd>TmuxNavigateLeft<CR>',  { desc = 'Tmux navigate left',  silent = true })
vim.keymap.set('n', '<C-j>', '<cmd>TmuxNavigateDown<CR>',  { desc = 'Tmux navigate down',  silent = true })
vim.keymap.set('n', '<C-k>', '<cmd>TmuxNavigateUp<CR>',    { desc = 'Tmux navigate up',    silent = true })
vim.keymap.set('n', '<C-l>', '<cmd>TmuxNavigateRight<CR>', { desc = 'Tmux navigate right', silent = true })
vim.keymap.set('n', '<C-\\>', '<cmd>TmuxNavigatePrevious<CR>', { desc = 'Tmux navigate previous', silent = true })
-- terminal
vim.keymap.set('t', '<C-h>', '<cmd>TmuxNavigateLeft<CR>',  { desc = 'Tmux navigate left',  silent = true })
vim.keymap.set('t', '<C-j>', '<cmd>TmuxNavigateDown<CR>',  { desc = 'Tmux navigate down',  silent = true })
vim.keymap.set('t', '<C-k>', '<cmd>TmuxNavigateUp<CR>',    { desc = 'Tmux navigate up',    silent = true })
vim.keymap.set('t', '<C-l>', '<cmd>TmuxNavigateRight<CR>', { desc = 'Tmux navigate right', silent = true })

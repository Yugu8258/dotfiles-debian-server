-- Interactive tools, navigation, search, and git integration

-- Toggleable terminal. See `:help toggleterm`
require('toggleterm').setup {
  open_mapping = [[<D-j>]],
  insert_mappings = true,
  terminal_mappings = true,
  direction = 'float',
  float_opts = {
    border = 'curved',
    width = 145,
    height = 45,
  },
}

-- Minimal file explorer. See `:help oil`
require('oil').setup({
  delete_to_trash = false,
  skip_confirm_for_simple_edits = true,
  constrain_cursor = "editable",
  view_options = {
    show_hidden = true,
  },
  float = {
    padding = 2,
    max_width = 120,
    max_height = 40,
    border = "rounded",
    override = function(conf)
      local width = math.min(120, math.max(20, vim.o.columns - 4))
      local height = math.min(40, math.max(10, vim.o.lines - 4))
      conf.width = width
      conf.height = height
      conf.col = math.floor((vim.o.columns - width) / 2)
      conf.row = math.floor((vim.o.lines - height) / 2)
      return conf
    end,
  },
})
vim.keymap.set('n', '<leader>-', '<cmd>lua require("oil").open_float()<CR>', { desc = 'Open parent directory (float)' })

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

-- ========== vim-tmux-navigator keymaps  ==========
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

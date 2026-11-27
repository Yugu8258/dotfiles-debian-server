-- UI appearance, theme overrides, indent guides, column guide, and rainbow delimiters

-- Colorscheme. `ayu mirage`
require('ayu').setup {
  mirage = true,
  overrides = {
    Normal = { bg = vim.g.neovide and "#212836" or "None" },
    NormalFloat = { bg = vim.g.neovide and "#212836" or "None" },
    SignColumn = { bg = "None" },

    -- Current line number (Ayu Mirage warm orange)
    CursorLineNr = { fg = "#FFA759", bg = "None", bold = true },
    -- Relative line numbers above and below cursor
    LineNrAbove = { fg = "#5C6773", bg = "None" },
    LineNrBelow = { fg = "#5C6773", bg = "None" },
    -- Fallback standard line number
    LineNr = { fg = "#707A8C", bg = "None" },
    -- Subtle cursorline background
    CursorLine = { bg = "#283040" },
  },
}
vim.cmd.colorscheme 'ayu'

-- Rainbow delimiters palette applied after buffer open and colorscheme changes
local function apply_rainbow_delimiters_hl()
  local palette = {
    love = '#eb6f92',
    gold = '#f6c177',
    pine = '#3e8fb0',
    rose = '#ea9a97',
    leaf = '#95b1ac',
    iris = '#c4a7e7',
    foam = '#9ccfd8',
  }

  vim.api.nvim_set_hl(0, 'RainbowDelimiterRed', { fg = palette.love })
  vim.api.nvim_set_hl(0, 'RainbowDelimiterYellow', { fg = palette.gold })
  vim.api.nvim_set_hl(0, 'RainbowDelimiterBlue', { fg = palette.pine })
  vim.api.nvim_set_hl(0, 'RainbowDelimiterOrange', { fg = palette.rose })
  vim.api.nvim_set_hl(0, 'RainbowDelimiterGreen', { fg = palette.leaf })
  vim.api.nvim_set_hl(0, 'RainbowDelimiterViolet', { fg = palette.iris })
  vim.api.nvim_set_hl(0, 'RainbowDelimiterCyan', { fg = palette.foam })
end

local rainbow_group = vim.api.nvim_create_augroup('user-rainbow-delimiters', { clear = true })
vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
  desc = 'Apply rainbow delimiter highlights when opening a buffer',
  group = rainbow_group,
  once = true,
  callback = apply_rainbow_delimiters_hl,
})
vim.api.nvim_create_autocmd('ColorScheme', {
  desc = 'Re-apply rainbow delimiter highlights after colorscheme changes',
  group = rainbow_group,
  callback = apply_rainbow_delimiters_hl,
})

-- Load snacks early with only the indent module enabled. See `:help snacks-indent`
local ok_snacks, snacks = pcall(require, 'snacks')
if ok_snacks then
  snacks.setup {
    indent = {
      enabled = true,
      char = '│',
      scope = {
        enabled = true,
      },
      chunk = {
        enabled = false,
      },
    },
    -- Explicitly disable unused modules to avoid unintended side effects
    dashboard = { enabled = false },
    picker = { enabled = false },
    explorer = { enabled = false },
    layout = { enabled = false },
    win = { enabled = false },
    input = { enabled = false },
    quickfile = { enabled = false },
    image = { enabled = false },
    scroll = { enabled = false },
  }
end

-- Virtual column guide at column 120. See `:help virt-column`
local virt_column_group = vim.api.nvim_create_augroup('user-virt-column', { clear = true })
vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
  desc = 'Setup virt-column when opening a buffer',
  group = virt_column_group,
  once = true,
  callback = function()
    -- Safely load plugin so startup is never blocked on failure
    local ok, virt_column = pcall(require, 'virt-column')
    if not ok then
      return
    end

    virt_column.setup {
      -- Column guide at character 120 matching textwidth = 120
      virtcolumn = '120',
      char = '│',
      highlight = 'NonText',
      exclude = {
        filetypes = {
          'alpha',
          'dashboard',
          'neo-tree',
          'toggleterm',
          'lazy',
          'mason',
          'TelescopePrompt',
          'notify',
        },
        buftypes = {
          'terminal',
          'quickfix',
          'help',
          'nofile',
          'prompt',
        },
      },
    }
  end,
})

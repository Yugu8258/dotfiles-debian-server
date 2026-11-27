-- Using the built-in plugin manager. See `:help vim.pack`.
-- Update with `:lua vim.pack.update()`.

vim.pack.add {
    'https://github.com/folke/snacks.nvim',
    'https://github.com/Shatur/neovim-ayu',
    'https://github.com/lewis6991/gitsigns.nvim',
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/nvim-telescope/telescope.nvim',
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/stevearc/oil.nvim',
    'https://github.com/christoomey/vim-tmux-navigator',
    'https://github.com/akinsho/toggleterm.nvim',
    'https://github.com/lukas-reineke/virt-column.nvim',
    'https://github.com/rmagatti/alternate-toggler',
    'https://github.com/HiPhish/rainbow-delimiters.nvim',
    'https://github.com/nvim-tree/nvim-web-devicons',
    'https://github.com/nvim-lualine/lualine.nvim',
}

-- Set rainbow delimiter highlight groups before plugin initialization
vim.g.rainbow_delimiters = {
    highlight = {
        'RainbowDelimiterRed',
        'RainbowDelimiterYellow',
        'RainbowDelimiterBlue',
        'RainbowDelimiterOrange',
        'RainbowDelimiterGreen',
        'RainbowDelimiterViolet',
        'RainbowDelimiterCyan',
    },
}

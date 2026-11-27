-- UI appearance, theme overrides, indent guides, column guide, rainbow delimiters, and statusline

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

-- Statusline setup. See `:help lualine`
local function setup_lualine()
    local ok_icons, devicons = pcall(require, 'nvim-web-devicons')
    if ok_icons then
        devicons.setup()
    end

    local ok_lualine, lualine = pcall(require, 'lualine')
    if not ok_lualine then
        return
    end

    -- Detect OS icon
    local os_icon = ''
    local sys = vim.uv.os_uname().sysname

    if sys == 'Darwin' then
        os_icon = ''
    elseif sys == 'Windows_NT' then
        os_icon = ''
    else
        local ok_rel, content = pcall(vim.fn.readfile, '/etc/os-release')
        if ok_rel then
            local release = table.concat(content)
            if release:find('ID=ubuntu') then
                os_icon = ''
            elseif release:find('ID=arch') then
                os_icon = ''
            elseif release:find('ID=kali') then
                os_icon = ''
            end
        end
    end

    -- Transparent rose palette theme
    local rose_theme = {
        normal = {
            a = { fg = '#e0def4', bg = 'none', gui = 'bold' },
            b = { fg = '#9ccfd8', bg = 'none' },
            c = { fg = '#6e6a86', bg = 'none' },
            x = { fg = '#6e6a86', bg = 'none' },
            y = { fg = '#ebbcba', bg = 'none' },
            z = { fg = '#c4a7e7', bg = 'none', gui = 'bold' },
        },
        insert = { a = { fg = '#9ccfd8', bg = 'none', gui = 'bold' } },
        visual = { a = { fg = '#c4a7e7', bg = 'none', gui = 'bold' } },
        replace = { a = { fg = '#eb6f92', bg = 'none', gui = 'bold' } },
        command = { a = { fg = '#f6c177', bg = 'none', gui = 'bold' } },
        inactive = {
            a = { fg = '#6e6a86', bg = 'none' },
            b = { fg = '#6e6a86', bg = 'none' },
            c = { fg = '#6e6a86', bg = 'none' },
        },
    }

    local function apply_transparent_statusline()
        vim.api.nvim_set_hl(0, 'StatusLine', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = 'none' })
    end

    apply_transparent_statusline()

    local lualine_group = vim.api.nvim_create_augroup('user-lualine', { clear = true })
    vim.api.nvim_create_autocmd('ColorScheme', {
        desc = 'Re-apply transparent statusline highlights after colorscheme changes',
        group = lualine_group,
        callback = apply_transparent_statusline,
    })

    lualine.setup {
        options = {
            theme = rose_theme,
            component_separators = { left = '', right = '' },
            section_separators = { left = '', right = '' },
            globalstatus = true,
            disabled_filetypes = {},
        },
        sections = {
            lualine_a = { 'mode' },
            lualine_b = { 'branch', 'diff', 'diagnostics' },
            lualine_c = { 'filename' },
            lualine_x = { 'encoding', 'fileformat', 'filetype' },
            lualine_y = {
                { os_icon, color = { fg = '#ebbcba' } },
                'progress',
            },
            lualine_z = { 'location' },
        },
        extensions = { 'nvim-tree', 'toggleterm' },
    }
end

local lualine_defer_group = vim.api.nvim_create_augroup('user-lualine-defer', { clear = true })
vim.api.nvim_create_autocmd('VimEnter', {
    desc = 'Load lualine after startup completes',
    group = lualine_defer_group,
    once = true,
    callback = function()
        vim.schedule(setup_lualine)
    end,
})

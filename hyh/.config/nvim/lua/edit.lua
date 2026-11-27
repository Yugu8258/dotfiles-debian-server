-- Editing enhancements: Treesitter parsers/highlighting, alternate toggling, and completion

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

-- Toggle alternate values under cursor. See `:help alternate-toggler`
local ok_alt, alt = pcall(require, 'alternate-toggler')
if ok_alt then
    alt.setup {
        alternates = {
            -- Booleans (case variants)
            { 'true', 'false' },
            { 'True', 'False' },
            { 'TRUE', 'FALSE' },
            -- Comparison operators
            { '===',  '!==' },
            { '==',   '!=' },
        },
    }
    vim.keymap.set('n', '<leader>i', '<cmd>ToggleAlternate<CR>', { desc = 'Toggle alternate word/operator' })
end

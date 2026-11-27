---@type vim.lsp.Config
return {
    cmd = {
        'lua-language-server',
        '--logpath=' .. vim.fn.expand('~/.cache/lua-language-server/log'),
    },
    filetypes = { 'lua' },
    root_markers = { '.luarc.json', '.stylua.toml', '.git' },
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT' },
            format = { enable = true },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
        },
    },
}

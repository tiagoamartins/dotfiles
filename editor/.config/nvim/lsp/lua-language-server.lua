return {
    cmd = {'lua-language-server'},
    filetypes = {
        'lua',
    },
    root_markers = {
        '.luarc.json',
        '.luarc.jsonc',
        '.git',
    },
    settings = {
        Lua = {
            diagnostics = {
                globals = {
                    'vim',
                },
            },
            runtime = {
                -- tell the language server which version of Lua you're
                -- using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- tell the language server how to find Lua modules same way
                -- as Neovim (see `:h lua-module-load`)
                path = {
                    'lua/?.lua',
                    'lua/?/init.lua',
                },
            },
            -- make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                    "${3rd}/luv/library",
                },
            },
        },
    },
}

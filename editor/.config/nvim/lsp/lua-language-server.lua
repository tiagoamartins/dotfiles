return {
    cmd = {'lua-language-server'},
    filetypes = {
        'lua',
    },
    root_markers = {
        '.luarc.json',
        '.luarc.jsonrc',
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
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if
                path ~= vim.fn.stdpath('config')
                        and (vim.uv.fs_stat(path .. '/.luarc.json')
                             or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
            then
                return
            end
        end
    end,
}

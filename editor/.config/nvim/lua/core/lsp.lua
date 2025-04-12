local M = {}
local cfg = require('config.lsp')

function M.on_attach(client, buffer)
    local bopt = vim.bo[buffer]

    for _, kmap in ipairs(cfg.get_default_keymaps()) do
        if not kmap.has or client.server_capabilities[kmap.has] then
            vim.keymap.set(kmap.mode or 'n', kmap.keys, kmap.exec, {
                buffer = buffer,
                desc = 'LSP: ' .. kmap.desc,
            })
        end
    end


    for _, opt in ipairs(cfg.get_default_options()) do
        if not opt.has or client.server_capabilities[opt.has] then
            bopt[opt.name] = opt.value
        end
    end

    for _, cmd in ipairs(cfg.get_default_commands()) do
        if not cmd.has or client.server_capabilities[cmd.has] then
            vim.api.nvim_buf_create_user_command(
                buffer, cmd.name, cmd.exec(client, buffer), {
                    desc = 'LSP: ' .. cmd.desc
                }
            )
        end
    end
end

function M.get_servers()
    local servers = {}

    for _, v in ipairs(vim.api.nvim_get_runtime_file("lsp/*", true)) do
        local name = vim.fn.fnamemodify(v, ":t:r")
        table.insert(servers, name)
    end

    return servers
end

local servers = M.get_servers()

vim.lsp.config('*', {
    on_attach = M.on_attach,
    root_markers = {
        '.git',
    },
})

vim.lsp.enable(servers)

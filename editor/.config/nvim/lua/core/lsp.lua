local cfg = require('config.lsp')

local servers = cfg.get_servers()

local function on_attach(client, buffer)
    local settings = client.config or {}

    if type(settings.server_capabilities) == 'table' then
        for k, v in pairs(settings.server_capabilities) do
            if v == vim.NIL then
                v = nil
            end

            client.server_capabilities[k] = v
        end
    end

    local function supported(item)
        return not item.has or client:supports_method(item.has, buffer)
    end

    for _, kmap in ipairs(cfg.get_default_keymaps()) do
        if supported(kmap) then
            vim.keymap.set(kmap.mode or 'n', kmap.keys, kmap.exec, {
                buffer = buffer,
                desc = 'LSP: ' .. kmap.desc,
            })
        end
    end

    for _, cmd in ipairs(cfg.get_default_commands()) do
        if supported(cmd) then
            vim.api.nvim_buf_create_user_command(
                buffer, cmd.name, cmd.exec(client, buffer), {
                    desc = 'LSP: ' .. cmd.desc
                }
            )
        end
    end
end

vim.lsp.config('*', {
    on_attach = on_attach,
    root_markers = {
        '.git',
    },
})

vim.lsp.enable(servers)

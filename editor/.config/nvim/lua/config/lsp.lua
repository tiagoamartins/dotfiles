local M = {}

function M.get_default_keymaps()
    local kmaps = {
        {
            keys = 'gD',
            desc = '[G]o to [D]eclaration',
            exec = vim.lsp.buf.declaration,
            has = 'textDocument/declaration',
        },
        {
            keys = 'gd',
            desc = '[G]o to [D]efinition',
            exec = vim.lsp.buf.definition,
            has = 'textDocument/definition',
        },
        {
            keys = '<leader>k',
            desc = 'Signature Documentation',
            exec = vim.lsp.buf.signature_help,
            has = 'textDocument/signatureHelp',
        },
        {
            keys = '<leader>wa',
            desc = '[W]orkspace [A]dd Folder',
            exec = vim.lsp.buf.add_workspace_folder,
            has = 'workspace/didChangeWorkspaceFolders',
        },
        {
            keys = '<leader>wr',
            desc = '[W]orkspace [R]emove Folder',
            exec = vim.lsp.buf.remove_workspace_folder,
            has = 'workspace/didChangeWorkspaceFolders',
        },
        {
            keys = '<leader>wl',
            desc = '[W]orkspace [L]ist Folders',
            exec = function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end,
            has = 'workspace/didChangeWorkspaceFolders',
        },
        {
            keys = '<leader>lv',
            desc = 'Toggle in[L]ine [V]irtual text',
            exec = function()
                local cfg = vim.diagnostic.config() or {}
                vim.diagnostic.config({virtual_text = not cfg.virtual_text})
            end,
        },
    }

    local ok, telescope = pcall(require, 'telescope.builtin')
    if ok then
        table.insert(kmaps, {
            keys = 'gO',
            desc = 'Document Symbols',
            exec = telescope.lsp_document_symbols,
            has = 'textDocument/documentSymbol',
        })
        table.insert(kmaps, {
            keys = 'grr',
            desc = '[G]o to [R]eferences',
            exec = telescope.lsp_references,
            has = 'textDocument/references',
        })
        table.insert(kmaps, {
            keys = '<leader>ws',
            desc = '[W]orkspace [S]ymbols',
            exec = telescope.lsp_workspace_symbols,
            has = 'workspace/symbol',
        })
    end

    return kmaps
end

function M.get_default_commands()
    return {
        {
            name = 'Format',
            exec = function(client, buffer)
                return function(_)
                    vim.lsp.buf.format({bufnr = buffer, id = client.id})
                end
            end,
            desc = 'Format current buffer with LSP',
            has = 'textDocument/formatting',
        },
    }
end

function M.get_default_servers()
    local servers = {}

    for _, v in ipairs(vim.api.nvim_get_runtime_file('lsp/*.lua', true)) do
        local name = vim.fn.fnamemodify(v, ':t:r')
        local cfg = vim.lsp.config[name]
        local cmd = cfg and cfg.cmd

        if type(cmd) ~= 'table' or vim.fn.executable(cmd[1]) == 1 then
            table.insert(servers, name)
        end
    end

    return servers
end

function M.get_servers()
    return vim.g.language_servers or M.get_default_servers()
end

return M

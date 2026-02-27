local M = {}

function M.get_default_keymaps()
    local kmaps = {
        {
            keys = '<leader>ca',
            desc = '[C]ode [A]ction',
            exec = vim.lsp.buf.code_action,
            has = 'codeActionProvider'
        },
        {
            keys = 'gD',
            desc = '[G]o to [D]eclaration',
            exec = vim.lsp.buf.declaration,
            has = 'declarationProvider',
        },
        {
            keys = 'gd',
            desc = '[G]o to [D]efinition',
            exec = vim.lsp.buf.definition,
            has = 'definitionProvider',
        },
        {
            keys = 'K',
            desc = 'Hover Documentation',
            exec = vim.lsp.buf.hover,
            has = 'hoverProvider',
        },
        {
            keys = 'gI',
            desc = '[G]o to [I]mplementation',
            exec = vim.lsp.buf.implementation,
            has = 'implementationProvider',
        },
        {
            keys = '<leader>rn',
            desc = '[R]e[n]ame',
            exec = vim.lsp.buf.rename,
            has = 'renameProvider',
        },
        {
            keys = '<leader>k',
            desc = 'Signature Documentation',
            exec = vim.lsp.buf.signature_help,
            has = 'signatureHelpProvider',
        },
        {
            keys = 'gT',
            desc = '[G]o to [T]ype',
            exec = vim.lsp.buf.type_definition,
            has = 'typeDefinitionProvider',
        },
        {
            keys = '<leader>wa',
            desc = '[W]orkspace [A]dd Folder',
            exec = vim.lsp.buf.add_workspace_folder,
            has = 'workspace',
        },
        {
            keys = '<leader>wr',
            desc = '[W]orkspace [R]emove Folder',
            exec = vim.lsp.buf.remove_workspace_folder,
            has = 'workspace',
        },
        {
            keys = '<leader>wl',
            desc = '[W]orkspace [L]ist Folders',
            exec = function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end,
            has = 'workspace',
        },
        {
            keys = '<leader>l',
            desc = 'Toggle in[L]ine virtual text',
            exec = function()
                local cfg = vim.diagnostic.config() or {}
                if cfg.virtual_text then
                    vim.diagnostic.config({virtual_text = false})
                else
                    vim.diagnostic.config({virtual_text = true})
                end
            end,
        },
    }

    local ok, telescope = pcall(require, 'telescope.builtin')
    if ok then
        table.insert(kmaps, {
            keys = '<leader>ds',
            desc = '[D]ocument [S]ymbols',
            exec = telescope.lsp_document_symbols,
            has = 'documentSymbolProvider',
        })
        table.insert(kmaps, {
            keys = 'gr',
            desc = '[G]o to [R]eferences',
            exec = telescope.lsp_references,
            has = 'referencesProvider',
        })
        table.insert(kmaps, {
            keys = '<leader>ws',
            desc = '[W]orkspace [S]ymbols',
            exec = telescope.lsp_workspace_symbols,
            has = 'workspaceSymbolProvider',
        })
    end

    return kmaps
end

function M.get_default_options()
    return {
        {
            name = 'omnifunc',
            value = 'v:lua.vim.lsp.omnifunc',
            has = 'completionProvider',
        },
        {
            name = 'tagfunc',
            value = 'v:lua.vim.lsp.tagfunc',
            has = 'definitionProvider',
        },
    }
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
            has = 'formattingProvider',
        },
    }
end

function M.get_default_servers()
    local servers = {}

    for _, v in ipairs(vim.api.nvim_get_runtime_file("lsp/*", true)) do
        local name = vim.fn.fnamemodify(v, ":t:r")
        table.insert(servers, name)
    end

    return servers
end

function M.get_servers()
    return vim.g.language_servers or M.get_default_servers()
end

return M

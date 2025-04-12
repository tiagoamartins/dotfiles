local M = {}

function M.get_default_keymaps()
    local telescope = require('telescope.builtin')
    return {
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
            keys = '<leader>ds',
            desc = '[D]ocument [S]ymbols',
            exec = telescope.lsp_document_symbols,
            has = 'documentSymbolProvider',
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
            keys = 'gr',
            desc = '[G]o to [R]eferences',
            exec = telescope.lsp_references,
            has = 'referencesProvider',
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
            keys = '<leader>ws',
            desc = '[W]orkspace [S]ymbols',
            exec = telescope.lsp_workspace_symbols,
            has = 'workspaceSymbolProvider',
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
    }
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

return M

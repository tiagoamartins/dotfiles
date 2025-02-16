local M = {}

function M.map()
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, {desc = 'Go to previous diagnostic message'})
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, {desc = 'Go to next diagnostic message'})
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, {desc = 'Open floating diagnostic message'})
    vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, {desc = 'Open diagnostic list'})

    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = M.on_attach
    })
end

function M.on_attach(args)
    local bufnr = args.buf

    function nmap(keys, func, desc)
        if (desc) then
            desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, {buffer = bufnr, desc = desc})
    end

    local telescope = require('telescope.builtin')
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- mappings
    if client.server_capabilities.codeActionProvider then
        nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
    end
    if client.server_capabilities.completionProvider then
        vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
    end
    if client.server_capabilities.declarationProvider then
        nmap('gD', vim.lsp.buf.declaration, '[G]o to [D]eclaration')
    end
    if client.server_capabilities.definitionProvider then
        vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
        nmap('gd', vim.lsp.buf.definition, '[G]o to [D]efinition')
    end
    if client.server_capabilities.documentSymbolProvider then
        nmap('<leader>ds', telescope.lsp_document_symbols, '[D]ocument [S]ymbols')
    end
    if client.server_capabilities.formattingProvider then
        vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
            vim.lsp.buf.format({bufnr = args.buf, id = client.id})
        end, {desc = 'Format current buffer with LSP'})
    end
    if client.server_capabilities.hoverProvider then
        nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    end
    if client.server_capabilities.implementationProvider then
        nmap('gI', vim.lsp.buf.implementation, '[G]o to [I]mplementation')
    end
    if client.server_capabilities.referencesProvider then
        nmap('gr', telescope.lsp_references, '[G]o to [R]eferences')
    end
    if client.server_capabilities.renameProvider then
        nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    end
    if client.server_capabilities.signatureHelpProvider then
        nmap('<leader>k', vim.lsp.buf.signature_help, 'Signature Documentation')
    end
    if client.server_capabilities.typeDefinitionProvider then
        nmap('gT', vim.lsp.buf.type_definition, '[G]o to [T]ype')
    end
    if client.server_capabilities.workspaceSymbolProvider then
        nmap('<leader>ws', telescope.lsp_workspace_symbols, '[W]orkspace [S]ymbols')
    end
    if client.server_capabilities.workspace and client.server_capabilities.workspace.workspaceFolders then
        nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
        nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
        nmap('<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, '[W]orkspace [L]ist Folders')
    end
end

return M

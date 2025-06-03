local M = {}

function M.get_default_tools()
    return {
        'ansible-language-server',
        'ansible-lint',
        'asm-lsp',
        'autotools-language-server',
        'bash-language-server',
        'clangd',
        'debugpy',
        'harper-ls',
        'json-lsp',
        'lua-language-server',
        'marksman',
        'ruff',
        'verible',
        'yaml-language-server',
        'yamllint',
    }
end

function M.get_tools()
    return vim.g.tools_installed or M.get_default_tools()
end

return M

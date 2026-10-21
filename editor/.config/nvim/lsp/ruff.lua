-- ruff owns Python linting and formatting
return {
    cmd = {'ruff', 'server'},
    filetypes = {
        'python',
    },
    root_markers = {
        '.git',
        '.ruff.toml',
        'pyproject.toml',
        'ruff.toml',
    },
    server_capabilities = {
        hoverProvider = vim.NIL,
    },
}

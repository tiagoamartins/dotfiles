return {
    cmd = {'ruff', 'server'},
    filetypes = {
        'python',
    },
    root_markers = {
        '.ruff.toml',
        'pyproject.toml',
        'ruff.toml',
    },
}

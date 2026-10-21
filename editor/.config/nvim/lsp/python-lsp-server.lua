-- pylsp provides navigation/hover/completion (jedi)
return {
    cmd = {'pylsp'},
    filetypes = {'python'},
    root_markers = {
        '.git',
        'Pipfile',
        'pyproject.toml',
        'requirements.txt',
        'setup.cfg',
        'setup.py',
    },
    settings = {
        pylsp = {
            plugins = {
                autopep8 = {enabled = false},
                flake8 = {enabled = false},
                mccabe = {enabled = false},
                pycodestyle = {enabled = false},
                pyflakes = {enabled = false},
                pylint = {enabled = false},
                yapf = {enabled = false},
            },
        },
    },
    server_capabilities = {
        documentFormattingProvider = vim.NIL,
        documentRangeFormattingProvider = vim.NIL,
    },
}

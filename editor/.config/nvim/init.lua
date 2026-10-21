-- cache compiled Lua modules (faster startup)
vim.loader.enable()

-- leader is backslash
vim.g.mapleader = '\\'

-- setup temporary directory environment variable
vim.env.VIM_TEMP = vim.env.HOME .. '/.cache/nvim/temp'

-- disable python 2 support
vim.g.loaded_python_provider = 0

-- disable ruby support
vim.g.loaded_ruby_provider = 0

-- disable node js support
vim.g.loaded_node_provider = 0

-- disable perl support
vim.g.loaded_perl_provider = 0

-- core settings, autocmds, LSP, mappings; plugins are added with vim.pack
require('core')

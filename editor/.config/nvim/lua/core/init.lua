require('core.settings')
require('core.local')
require('core.autocmds')
require('core.lazy')
require('core.lsp')
require('core.mappings')
require('core.commands')

vim.cmd.colorscheme('moonfly')

statusline = require('core.statusline')
statusline.setup()

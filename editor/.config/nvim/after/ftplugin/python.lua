local set = vim.opt_local

set.formatoptions:remove('t')
set.foldmethod = 'manual'
set.textwidth = 79
set.smartindent = false

local bufnr = vim.api.nvim_get_current_buf()

vim.b[bufnr].c_textwidth = 72
vim.b[bufnr].c_formatoptions = 't' .. vim.api.nvim_buf_get_option(0, 'formatoptions')
vim.g.python_highlight_all = 1

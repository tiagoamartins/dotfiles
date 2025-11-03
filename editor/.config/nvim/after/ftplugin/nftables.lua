local set = vim.opt_local

set.smartindent = true
set.cindent = false
set.commentstring = '# %s'
set.formatoptions:remove('t')
set.formatoptions:append('croqnlj')
set.comments = 'b:#'

set.tabstop = 4
set.shiftwidth = 4
set.softtabstop = 4
set.expandtab = true
set.textwidth = 80

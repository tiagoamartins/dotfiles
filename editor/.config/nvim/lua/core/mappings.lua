-- register an internal keymap that wraps `fn` with vim-repeat
local make_repeatable_keymap = function(mode, map, fn)
   vim.validate({
      mode = {mode, {'string', 'table'}},
      fn = {
         fn,
         {'string', 'function'},
         map = {name = 'string'}
      }
   })
   if not vim.startswith(map, '<plug>') then
      error('`map` should start with `<plug>`, given: ' .. map)
   end

   vim.keymap.set(mode, map, function()
      fn()
      vim.fn['repeat#set'](vim.api.nvim_replace_termcodes(map, true, true, true))
   end)

   return map
end

-- leader {{{1
-- window swap
vim.keymap.set('n', '<leader>wm', require('core.window').mark_swap, {silent = true})
vim.keymap.set('n', '<leader>wp', require('core.window').do_swap, {silent = true})
-- turn off search highlight
vim.keymap.set('n', '<leader><space>', vim.cmd.nohlsearch)
-- remove trailing space
vim.keymap.set('n', '<leader>$', function() require('core.cursor').preserve('%s/\\s\\+$//e') end)
-- indent entire file
vim.keymap.set('n', '<leader>=', function() require('core.cursor').preserve('normal gg=G') end)
-- edit vimrc
vim.keymap.set('n', '<leader>ev', function() vim.cmd.vsplit(vim.env.MYVIMRC) end)
-- load vimrc
vim.keymap.set('n', '<leader>sv', function() vim.cmd.source(vim.env.MYVIMRC) end)
-- call fugitive
vim.keymap.set('n', '<leader>git', vim.cmd.Git)
-- change spelling language
vim.keymap.set('n', '<leader>en', function() vim.opt.spelllang=en_us end, {silent = true})
vim.keymap.set('n', '<leader>pt', function() vim.opt.spelllang=pt_br end, {silent = true})
-- replace without loosing current yank
vim.keymap.set('v', '<leader>p', '"_dp')
vim.keymap.set('v', '<leader>P', '"_dP')

-- tests {{{2
vim.keymap.set('n', '<leader>tn', vim.cmd.TestNearest, {silent = true, remap = true})
vim.keymap.set('n', '<leader>tf', vim.cmd.TestFile, {silent = true, remap = true})
vim.keymap.set('n', '<leader>ts', vim.cmd.TestSuite, {silent = true, remap = true})
vim.keymap.set('n', '<leader>tl', vim.cmd.TestLast, {silent = true, remap = true})
vim.keymap.set('n', '<leader>tv', vim.cmd.TestVisit, {silent = true, remap = true})

-- tabularize {{{2
vim.keymap.set('n', '<leader>a=', function() vim.cmd.Tabularize('/^[^<=]*\\zs<=') end, {buffer = true})
vim.keymap.set('v', '<leader>a=', function() vim.cmd.Tabularize('/^[^<=]*\\zs<=') end, {buffer = true})
vim.keymap.set('n', '<leader>a:', function() vim.cmd.Tabularize('/^[^:]*\\zs:') end, {buffer = true})
vim.keymap.set('v', '<leader>a:', function() vim.cmd.Tabularize('/^[^:]*\\zs:') end, {buffer = true})

-- function keys {{{1
-- toggle spelling
vim.keymap.set({'n', 'c'}, '<f4>', function()
   vim.opt.spell = not vim.opt.spell:get()
   vim.print('spell check: ' .. (vim.opt.spell:get() and 'on' or 'off'))
end)

vim.keymap.set('n', '<f9>', vim.cmd.Dispatch)
vim.keymap.set('n', '<f10>', vim.cmd.Mbuild)

-- normal mode {{{1
-- set space to toggle a fold
vim.keymap.set('n', '<space>', 'za')
-- swap two characters with capability of repeat by '.' (using repeat plugin)
vim.keymap.set('n', 'cp', make_repeatable_keymap(
   {'n', 'c'},
   '<plug>TransposeChars', function()
      vim.cmd.normal('xph')
   end), {remap = true})
-- highlight last inserted text
vim.keymap.set('n', 'gV', '`[v`]')

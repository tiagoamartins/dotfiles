vim.pack.add({'https://github.com/nickjvandyke/opencode.nvim'})

vim.g.opencode_opts = {}

local mappings = {
    {'<leader>Oa', function() require('opencode').ask('@this: ') end, mode = {'n', 'x'}, desc = 'Ask opencode…'},
    {'<leader>Os', function() require('opencode').select() end, mode = {'n', 'x'}, desc = 'Select opencode action…'},
    {'<leader>Oo',  function() return require('opencode').operator('@this ') end, mode = {'n', 'x'}, expr = true, desc = 'Add range to opencode'},
    {'<leader>Ooo', function() return require('opencode').operator('@this ') .. '_' end, mode = 'n', expr = true, desc = 'Add line to opencode'},
}

require('core.keymap').set(mappings)

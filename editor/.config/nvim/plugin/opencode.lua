vim.pack.add({'https://github.com/nickjvandyke/opencode.nvim'})

vim.o.autoread = true -- Required for `opts.events.reload`

local mappings = {
    {'<leader>Oa', function() require('opencode').ask('@this: ', {submit = true}) end, desc = 'Ask opencode…'},
    {'<leader>Ox', function() require('opencode').select() end, desc = 'Execute opencode action…'},
    {'<leader>go',  function() return require('opencode').operator('@this ') end, desc = 'Add range to opencode', expr = true},
    {'<leader>goo', function() return require('opencode').operator('@this ') .. '_' end, desc = 'Add line to opencode', expr = true},
    {'<leader>Ou', function() require('opencode').command('session.half.page.up') end, desc = 'Scroll OpenCode up'},
    {'<leader>Od', function() require('opencode').command('session.half.page.down') end, desc = 'Scroll OpenCode down'},
}

for _, opts in pairs(mappings) do
    local lhs = opts[1]
    local rhs = opts[2]

    table.remove(opts, 1)
    table.remove(opts, 1)
    vim.keymap.set('n', lhs, rhs, opts)
end

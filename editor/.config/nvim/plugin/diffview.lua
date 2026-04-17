vim.pack.add({'https://github.com/sindrets/diffview.nvim'})

require('diffview').setup({
    use_icons = false
})

local mappings = {
    {'<leader>db', '<cmd>DiffviewFileHistory<cr>', desc = '[D]iff view [B]ranch'},
    {'<leader>dcl', '<cmd>DiffviewClose<cr>', desc = '[D]iff view [CL]ose'},
    {'<leader>df', '<cmd>DiffviewFileHistory %<cr>', desc = '[D]iff view [F]ile'},
    {'<leader>do', '<cmd>DiffviewOpen<cr>', desc = '[D]iff view [O]pen'},
    {'<leader>dO', ':DiffviewOpen ', desc = '[D]iff view [O]pen Prompt'},
    {'<leader>dr', '<cmd>DiffviewRefresh<cr>', desc = '[D]iff view [R]efresh'},
}

for _, opts in pairs(mappings) do
    local lhs = opts[1]
    local rhs = opts[2]

    table.remove(opts, 1)
    table.remove(opts, 1)
    vim.keymap.set('n', lhs, rhs, opts)
end

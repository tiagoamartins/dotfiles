return {
    'sindrets/diffview.nvim',
    cmd = {
        'DiffviewClose',
        'DiffviewFileHistory',
        'DiffviewFocusFiles',
        'DiffviewLog',
        'DiffviewOpen',
        'DiffviewRefresh',
        'DiffviewToggleFiles',
    },
    keys = {
        {'<leader>db', '<cmd>DiffviewFileHistory<cr>', desc = '[D]iff view [B]ranch'},
        {'<leader>dcl', '<cmd>DiffviewClose<cr>', desc = '[D]iff view [CL]ose'},
        {'<leader>df', '<cmd>DiffviewFileHistory %<cr>', desc = '[D]iff view [F]ile'},
        {'<leader>do', '<cmd>DiffviewOpen<cr>', desc = '[D]iff view [O]pen'},
        {'<leader>dr', '<cmd>DiffviewRefresh<cr>', desc = '[D]iff view [R]efresh'},
    },
    opts = {
        use_icons = false
    }
}

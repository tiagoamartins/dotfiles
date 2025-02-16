return {
    'sindrets/diffview.nvim',
    keys = {
        {'<leader>db', '<cmd>DiffviewFileHistory<cr>', desc = '[D]iff view [B]ranch'},
        {'<leader>df', '<cmd>DiffviewFileHistory %<cr>', desc = '[D]iff view [F]ile'},
        {'<leader>dcl', '<cmd>DiffviewClose<cr>', desc = '[D]iff view [CL]ose'},
    },
    opts = {
        use_icons = false
    }
}

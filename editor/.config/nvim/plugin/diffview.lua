vim.pack.add({'https://github.com/sindrets/diffview.nvim'})

require('diffview').setup({
    use_icons = false,
    hooks = {
        diff_buf_read = function(bufnr)
            vim.opt_local.wrap = true
        end,
    },
    view = {
        merge_tool = {
            layout = 'diff4_mixed',
            disable_diagnostics = true,
            winbar_info = true,
        },
    },
})

local mappings = {
    {'<leader>db', '<cmd>DiffviewFileHistory<cr>', desc = '[D]iff view [B]ranch'},
    {'<leader>dcl', '<cmd>DiffviewClose<cr>', desc = '[D]iff view [CL]ose'},
    {'<leader>df', '<cmd>DiffviewFileHistory %<cr>', desc = '[D]iff view [F]ile'},
    {'<leader>do', '<cmd>DiffviewOpen<cr>', desc = '[D]iff view [O]pen'},
    {'<leader>dO', ':DiffviewOpen ', desc = '[D]iff view [O]pen Prompt'},
    {'<leader>dr', '<cmd>DiffviewRefresh<cr>', desc = '[D]iff view [R]efresh'},
}

require('core.keymap').set(mappings)

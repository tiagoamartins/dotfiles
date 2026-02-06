return {
    'mfussenegger/nvim-ansible',
    cond = function()
        return vim.fn.executable('ansible') == 1
    end,
    ft = {'ansible'},
}

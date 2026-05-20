vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead', 'BufFilePost'}, {
    pattern = '*.rdl',
    callback = function ()
        vim.opt_local.filetype = 'systemrdl'
    end
})

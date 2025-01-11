vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
    pattern = '*.h',
    callback = function ()
        vim.opt_local.filetype = 'c'
    end
})

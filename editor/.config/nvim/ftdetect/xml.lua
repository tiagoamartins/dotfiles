vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
    pattern = '*.rss',
    callback = function ()
        vim.opt_local.filetype = 'xml'
    end
})

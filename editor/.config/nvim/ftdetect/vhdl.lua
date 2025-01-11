vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
    pattern = {'*.vhd', '*.vhdl'},
    callback = function ()
        vim.opt_local.filetype = 'vhdl'
    end
})

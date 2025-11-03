vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
    pattern = '*',
    callback = function ()
        local r = vim.regex(
            [[^#!\s*\%\(/\S\+\)\?/\%\(s\)\?bin/\%\(env\s\+\)\?nft\>]]
        )
        if r:match_line(0, 0) then
            vim.opt_local.filetype = 'nftables'
        end
    end,
})

vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
    pattern = {'*.nft', 'nftables.conf'},
    callback = function ()
        vim.opt_local.filetype = 'nftables'
    end,
})

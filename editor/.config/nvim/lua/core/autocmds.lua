local tempdirs = '/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,*/tmp/*,/private$TMPDIR/*'

vim.api.nvim_create_augroup('line_return', {clear = true})
vim.api.nvim_create_autocmd('BufReadPost', {
    group = 'line_return',
    pattern = '*',
    callback = function ()
        local pos_exit = vim.fn.line('\'\"')
        local pos_last = vim.fn.line('$')

        if pos_exit > 0 and pos_exit <= pos_last then
            vim.cmd.normal('g`\"zvzz')
        end
    end
})

vim.api.nvim_create_augroup('swapskip', {clear = true})
vim.api.nvim_create_autocmd({'BufNewFile', 'BufReadPre'}, {
    group = 'swapskip',
    pattern = tempdirs,
    callback = function ()
        vim.opt_local.swapfile = false
    end
})

vim.api.nvim_create_augroup('undoskip', {clear = true})
vim.api.nvim_create_autocmd('BufWritePre', {
    group = 'undoskip',
    pattern = tempdirs,
    callback = function ()
        vim.opt_local.undofile = false
    end
})


vim.api.nvim_create_augroup('viminfoskip', {clear = true})
vim.api.nvim_create_autocmd({'BufNewFile', 'BufReadPre'}, {
    group = 'viminfoskip',
    pattern = tempdirs,
    callback = function ()
        vim.opt_local.viminfo = ''
    end
})

vim.api.nvim_create_augroup('yank', {clear = true})
vim.api.nvim_create_autocmd('TextYankPost', {
    group = 'yank',
    pattern = '*',
    callback = function ()
        if vim.v.event.operator == 'y' and vim.v.event.regname == '+' then
            require('core.yank').osc52(vim.v.event.regcontents)
        end
    end
})

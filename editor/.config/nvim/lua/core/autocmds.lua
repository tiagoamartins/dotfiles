local tempdirs = '/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,*/tmp/*,/private$TMPDIR/*'
local augroups = {}

augroups.editing = {
    restore_cursor = {
        event = {'BufReadPost'},
        pattern = '*',
        callback = function ()
            local pos_exit = vim.fn.line('\'\"')
            local pos_last = vim.fn.line('$')

            if pos_exit > 0 and pos_exit <= pos_last then
                vim.cmd.normal('g`\"zvzz')
            end
        end
    },
}

augroups.secret = {
    disable_swapfile = {
        event = {'BufNewFile', 'BufReadPre'},
        pattern = tempdirs,
        callback = function ()
            vim.opt_local.swapfile = false
        end
    },
    disable_undofile = {
        event = {'BufWritePre'},
        pattern = tempdirs,
        callback = function ()
            vim.opt_local.undofile = false
        end
    },
    disable_viminfo = {
        event = {'BufNewFile', 'BufReadPre'},
        pattern = tempdirs,
        callback = function ()
            vim.opt_local.viminfo = ''
        end
    },
}

augroups.yank = {
    osc52 = {
        event = {'TextYankPost'},
        pattern = '*',
        callback = function ()
            if vim.v.event.operator == 'y' and vim.v.event.regname == '+' then
                require('core.yank').osc52(vim.v.event.regcontents)
            end
        end
    },
}

for group, cmds in pairs(augroups) do
    local augroup = vim.api.nvim_create_augroup('AU_' .. group, {clear = true})

    for _, opts in pairs(cmds) do
        local event = opts.event

        opts.event = nil
        opts.group = augroup

        vim.api.nvim_create_autocmd(event, opts)
    end
end

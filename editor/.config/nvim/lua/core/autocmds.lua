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

augroups.lsp = {
    auto_completion = {
        event = {'LspAttach'},
        pattern = '*',
        callback = function(ev)
            local client = vim.lsp.get_client_by_id(ev.data.client_id)
            if client:supports_method('textDocument/completion') then
                vim.lsp.completion.enable(true, client.id, ev.buf, {autotrigger = true})
            end
        end,
    }
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

augroups.treesitter = {
    highlight = {
        event = {'FileType'},
        pattern = require('config.treesitter').get_filetypes(),
        callback = function ()
            ok, _ = pcall(vim.treesitter.start)
            if ok then
                vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
        end,
    }
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

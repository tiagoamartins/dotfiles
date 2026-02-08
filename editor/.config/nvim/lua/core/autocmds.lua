local tempdirs = '/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,*/tmp/*,/private$TMPDIR/*'
local augroups = {}

augroups.config = {
    clear_jumplist = {
        event = {'VimEnter'},
        callback = function ()
            vim.cmd.clearjumps()
        end,
    },
    parent_dirs = {
        event = {'BufWritePre'},
        callback = function (ev)
            if not ev.file:find('^%w+://') then
                vim.fn.mkdir(vim.fs.dirname(ev.file), 'p')
            end
        end,
    },
    relative_paths = {
        event = {'BufReadPost'},
        callback = function ()
            vim.cmd.lcd('.')
        end,
    },
    resize_splits = {
        event = {'VimResized'},
        callback = function ()
            local ctab = vim.fn.tabpagenr()
            vim.cmd.tabdo('wincmd =')
            vim.cmd.tabnext(ctab)
        end,
    }
}

augroups.editing = {
    insert_enter_diag = {
        event = {'ModeChanged'},
        pattern = '*:i',
        callback = function (ev)
            vim.diagnostic.enable(false, {bufnr = ev.buf})
        end,
    },
    inset_exit_diag = {
        event = {'ModeChanged'},
        pattern = 'i:*',
        callback = function (ev)
            vim.diagnostic.enable(true, {bufnr = ev.buf})
        end,
    },
    quickfix_numbering = {
        event = {'FileType'},
        pattern = 'qf',
        callback = function()
            vim.wo[0][0].relativenumber = false
            vim.wo[0][0].cursorline = true
        end,
    },
    restore_cursor = {
        event = {'BufReadPost'},
        callback = function (ev)
            local lastpos = vim.api.nvim_buf_get_mark(ev.buf, '"')
            if pcall(vim.api.nvim_win_set_cursor, 0, lastpos) then
            vim.cmd.normal({'zz', bang = true})
            end
        end,
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

augroups.treesitter = {
    highlight = {
        event = {'FileType'},
        pattern = require('config.treesitter').get_filetypes(),
        callback = function (ev)
            local ok, _ = pcall(vim.treesitter.start)
            if ok then
                if vim.treesitter.query.get(ev.match, 'folds') then
                    vim.wo[0][0].foldmethod = 'expr'
                    vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
                end
                if vim.treesitter.query.get(ev.match, 'indent') then
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
            end
        end,
    }
}

augroups.visual = {
    todos = {
        event = {'BufWinEnter', 'WinNew'},
        callback = function()
            vim.schedule(function()
                if vim.w.todo_match then
                    return
                end
                if vim.bo.buftype == '' then
                    vim.fn.matchadd('Todo', [[\<\(TODO\|FIXME\|HACK\|NOTE\|XXX\)\>:\=]], 0)
                    vim.w.todo_match = true
                end
            end)
        end,
    },
    trail = {
        event = {'BufWinEnter', 'WinNew'},
        callback = function()
            vim.schedule(function()
                if vim.w.trailing_ws_match then
                    return
                end
                if vim.bo.buftype == '' then
                    vim.fn.matchadd('TrailingWhitespace', [[\s\+$]], 0)
                    vim.w.trailing_ws_match = true
                end
            end)
        end,
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

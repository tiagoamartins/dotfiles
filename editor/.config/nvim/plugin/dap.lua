if require('config.tools').has_debuggers() then
    vim.pack.add({
        'https://github.com/mfussenegger/nvim-dap',
        'https://github.com/igorlfs/nvim-dap-view',
        'https://github.com/thehamsta/nvim-dap-virtual-text',
    })

    local dap = require('dap')
    local handlers = require('config.dap-handlers')

    dap.defaults.fallback.terminal_win_cmd = [[ belowright new ]]
    dap.defaults.fallback.switchbuf = 'useopen'

    local augroup = vim.api.nvim_create_augroup('AU_dap', {clear = true})

    -- close the debuggee terminal when it exits cleanly; scoped to dap's
    -- "[dap-terminal] ..." buffers so other terminals are left alone
    vim.api.nvim_create_autocmd('TermClose', {
        group = augroup,
        pattern = '*dap-terminal*',
        callback = function(ev)
            if vim.v.event.status == 0 then
                vim.api.nvim_buf_delete(ev.buf, {force = true})
            end
        end,
    })
    vim.api.nvim_create_autocmd('FileType', {
        group = augroup,
        pattern = 'dap-repl',
        callback = function()
            require('dap.ext.autocompl').attach()
        end,
    })

    local repl = require('dap.repl')
    repl.commands = vim.tbl_extend('force', repl.commands, {
        exit = {'exit', '.exit', '.bye'},
        custom_commands = {
            ['.echo'] = function(text)
                dap.repl.append(text)
            end,
            ['.restart'] = dap.restart,
        }
    })

    vim.api.nvim_create_user_command("RunScriptWithArgs", function(t)
        -- :help nvim_create_user_command
        local args = vim.split(vim.fn.expand(t.args), '\n')
        local approval = vim.fn.confirm(
            "Will try to run:\n    " ..
            vim.bo.filetype .. " " ..
            vim.fn.expand('%') .. " " ..
            t.args .. "\n\n" ..
            "Do you approve? ",
            "&Yes\n&No", 1
        )
        if approval == 1 then
            dap.run({
                type = vim.bo.filetype,
                request = 'launch',
                name = 'Launch file with custom arguments (adhoc)',
                program = '${file}',
                args = args,
            })
        end
        end, {
            complete = 'file',
            nargs = '*'
    })
    vim.keymap.set('n', '<leader>R', ":RunScriptWithArgs")
    vim.api.nvim_set_hl(0, "DapStoppedLine", {default = true, link = "Visual"})

    dap.adapters.python = function(cb, config)
        if config.request == 'attach' then
            ---@diagnostic disable-next-line: undefined-field
            local port = (config.connect or config).port
            ---@diagnostic disable-next-line: undefined-field
            local host = (config.connect or config).host or '127.0.0.1'
            cb({
                type = 'server',
                port = assert(port, '`connect.port` is required for a python `attach` configuration'),
                host = host,
                options = {
                    source_filetype = 'python',
                },
            })
        else
            cb({
                type = 'executable',
                command = vim.fn.exepath('debugpy-adapter'),
                options = {
                    source_filetype = 'python',
                },
            })
        end
    end

    dap.adapters.gdb = {
        id = 'gdb',
        type = 'executable',
        command = 'gdb',
        args = {'--quiet', '--interpreter=dap', '--eval-command', 'set print pretty on'}
    }

    dap.adapters.gdbarm = {
        id = 'gdbarm',
        type = 'executable',
        command = 'arm-none-eabi-gdb',
        args = {'--quiet', '--interpreter=dap', '--eval-command', 'set print pretty on'}
    }

    dap.adapters.vgdb = {
        id = 'vgdb',
        type = 'executable',
        command = 'vgdb',
        args = {'--quiet', '--interpreter=dap', '--eval-command', 'set print pretty on'}
    }

    dap.configurations.c = {
        {
            name = 'Launch',
            type = 'gdb',
            request = 'launch',
            program = handlers.get_executable,
            args = handlers.get_arguments,
            cwd = '${workspaceFolder}',
            stopAtBeginningOfMainSubprogram = true,
        },
        {
            name = 'Launch (valgrind)',
            type = 'vgdb',
            request = 'launch',
            program = handlers.get_executable,
            args = handlers.get_arguments,
            cwd = '${workspaceFolder}',
            stopAtBeginningOfMainSubprogram = true,
        },
        {
            name = 'Select and attach to process',
            type = 'gdb',
            request = 'attach',
            program = handlers.get_executable,
            pid = function()
                local name = vim.fn.input('Executable name (filter): ')
                return require('dap.utils').pick_process({filter = name})
            end,
            cwd = '${workspaceFolder}'
        },
        {
            name = 'Attach to gdbserver :1234',
            type = 'gdb',
            request = 'attach',
            target = 'localhost:1234',
            cwd = '${workspaceFolder}',
            program = handlers.get_executable,
            args = handlers.get_arguments,
            stopOnEntry = false,
            runInTerminal = false,
        },
        {
            name = 'Attach to gdbserver (ARM) :1234',
            type = 'gdbarm',
            request = 'attach',
            target = 'localhost:1234',
            cwd = '${workspaceFolder}',
            program = handlers.get_executable,
            args = handlers.get_arguments,
            stopOnEntry = false,
            runInTerminal = false,
        }
    }

    local venv_path = os.getenv('VIRTUAL_ENV') or os.getenv('CONDA_PREFIX')
    dap.configurations.python = {
        {
            type = 'python',
            request = 'launch',
            name = 'Python: Launch file',
            program = '${file}',
            pythonPath = venv_path and (venv_path .. '/bin/python') or nil,
            console = 'integratedTerminal',
        },
    }

    require('dap-view').setup()
    require('nvim-dap-virtual-text').setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
    })

    local mappings = {
        {'<leader>td', function() require('dap').terminate() end, desc = '[T]erminate [D]ebugging Session'},
        {'<leader>b', function() require('dap').toggle_breakpoint() end, desc = 'Add [B]reakpoint'},
        {'<leader>B', function()
            require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))
            end, desc = 'Add conditional [B]reakpoint'},
        {'<leader>lp', function()
            require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
            end, desc = 'Add [L]og [P]oint'},
        {'<leader>rd', function() require('dap').repl.toggle() end, desc = '[R]un [D]ebugging Session'},
        {'<leader>dl', function() require('dap').run_last() end, desc = '[D]ebug: run [L]ast session'},
        {'<leader>dw', '<cmd>DapViewWatch<cr>', desc = '[D]ebug: view [W]atch'},
        {'<leader>K', function()
            require('dap.ui.widgets').hover(nil, {border = 'rounded'})
        end, desc = 'DAP: Hover [K]'},
        {'<leader>S', function()
            local widgets = require('dap.ui.widgets')
            widgets.centered_float(widgets.scopes, {border = 'rounded'})
        end, desc = 'DAP: [S]copes'},
        {'<F3>', '<cmd>DapViewToggle<cr>', desc = 'DAP: Toggle view'},
        {'<F5>', function() require('dap').continue() end, desc = 'DAP: Start/continue'},
        {'<F6>', function() require('dap').step_into() end, desc = 'DAP: Step into'},
        {'<F7>', function() require('dap').step_over() end, desc = 'DAP: Step over'},
        {'<F8>', function() require('dap').step_out() end, desc = 'DAP: Step out'},
    }

    require('core.keymap').set(mappings)
end

local function config(_, opts)
    local dap = require('dap')
    local handlers = require('config.dap-handlers')

    dap.defaults.fallback.terminal_win_cmd = [[ belowright new ]]

    vim.cmd (
        [[autocmd TermClose *                     |]]..
        [[if !v:event.status                      |]]..
        [[    exe 'bdelete! ' .. expand('<abuf>') |]]..
        [[endif                                   ]]
    )
    vim.cmd([[au FileType dap-repl lua require('dap.ext.autocompl').attach()]])

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
        args = vim.split(vim.fn.expand(t.args), '\n')
        approval = vim.fn.confirm(
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

    vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

    local mason_dap = require('mason-nvim-dap')
    mason_dap.setup({
        ensure_installed = opts.adapters,
        handlers = handlers.setup_handlers()
    })

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
            stopAtBeginningOfMainSubprogram = false,
        },
        {
            name = 'Launch (valgrind)',
            type = 'gdb',
            request = 'launch',
            program = handlers.get_executable,
            args = handlers.get_arguments,
            cwd = '${workspaceFolder}',
            stopAtBeginningOfMainSubprogram = false,
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
end

return {
    'mfussenegger/nvim-dap',
    config = config,
    opts = {
        adapters = {'python'}
    },
    keys = {
        {'<leader>td', function() require('dap').terminate() end, desc = '[T]erminate [D]ebugging Session'},
        {'<leader>b', function() require('dap').toggle_breakpoint() end, desc = 'Add [B]reakpoint'},
        {'<leader>B', function()
            require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))
            end, desc = 'Add conditional [B]reakpoint'},
        {'<leader>lp', function()
            require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
            end, desc = 'Add [L]og [P]oint'},
        {'<leader>rd', function() require('dap').repl.toggle() end, desc = '[R]un [D]ebugging Session'},
        {'<leader>ld', function() require('dap').run_last() end, desc = 'Run [L]ast [D]ebugging Session'},
        {'<F5>', function() require('dap').continue() end, desc = 'DAP: Start/continue'},
        {'<F6>', function() require('dap').step_into() end, desc = 'DAP: Step into'},
        {'<F7>', function() require('dap').step_over() end, desc = 'DAP: Step over'},
        {'<F8>', function() require('dap').step_out() end, desc = 'DAP: Step out'},
    }
}

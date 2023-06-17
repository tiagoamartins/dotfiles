local function config()
	local dap = require('dap')

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
end

return {
	'mfussenegger/nvim-dap',
	lazy = true,
	config = config,
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
		{'<F6>', function() require('dap').step_over() end, desc = 'DAP: Step over'},
		{'<F7>', function() require('dap').step_into() end, desc = 'DAP: Step into'},
		{'<F8>', function() require('dap').step_out() end, desc = 'DAP: Step out'},
	},
	dependencies = {
		'rcarriga/nvim-dap-ui',
		'theHamsta/nvim-dap-virtual-text',
		'nvim-telescope/telescope-dap.nvim',
	}
}

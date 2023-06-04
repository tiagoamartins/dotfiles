local M = {}

function M.setup()
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

return M

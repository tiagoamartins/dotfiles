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

	dap.adapters = require('plugins.debug.adapters').all()
	dap.configurations = require('plugins.debug.configs').all()

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
end

return M

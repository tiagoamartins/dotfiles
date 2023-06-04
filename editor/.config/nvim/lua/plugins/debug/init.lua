return {
	{
		'mfussenegger/nvim-dap',
		lazy = true,
		config = function() require('plugins.debug.dap').setup() end,
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
			{
				'rcarriga/nvim-dap-ui',
				keys = {
					{'<f3>', function() require('dapui').toggle() end, desc = 'DAP: Activate UI'},
				},
				config = function() require('plugins.debug.dap_ui').setup() end,
			},
			{
				'theHamsta/nvim-dap-virtual-text',
				opts = require('plugins.debug.dap_vtxt').opts
			},
			{
				'nvim-telescope/telescope-dap.nvim',
				config = function() require('telescope').load_extension('dap') end,
				cond = function() return require('config.util').has('nvim-telescope') end
			},
		}
	}
}

return {
	{
		'mfussenegger/nvim-dap',
		lazy = true,
		config = function() require('plugins.debug.dap').setup() end,
		keys = {
			{'<leader>ds', [[<cmd>lua require('dap').terminate()<cr>]]},
			{'<leader>b', [[<cmd>lua require('dap').toggle_breakpoint()<cr>]]},
			{'<leader>B', [[<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>]]},
			{'<leader>lp', [[<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>]]},
			{'<leader>dr', [[<cmd>lua require('dap').repl.toggle()<cr>]]},
			{'<leader>dl', [[<cmd>lua require('dap').run_last()<cr>]]},
			{'<f5>', [[<cmd>lua require('dap').continue()<cr>]]},
			{'<f6>', [[<cmd>lua require('dap').step_over()<cr>]]},
			{'<f7>', [[<cmd>lua require('dap').step_into()<cr>]]},
			{'<f8>', [[<cmd>lua require('dap').step_out()<cr>]]},
		},
		dependencies = {
			{
				'rcarriga/nvim-dap-ui',
				keys = {
					{'<f3>', [[<cmd>lua require('dapui').toggle()<cr>]]},
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

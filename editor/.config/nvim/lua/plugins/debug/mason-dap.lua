return {
	'jay-babu/mason-nvim-dap.nvim',
	dependencies = {
		'williamboman/mason.nvim',
		'mfussenegger/nvim-dap'
	},
	opts = {
		ensure_installed = {'cppdbg', 'python'},
		handlers = require('plugins.debug.handlers').setup_handlers()
	}
}

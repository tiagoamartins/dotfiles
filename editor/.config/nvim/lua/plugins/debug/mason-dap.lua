return {
	'jay-babu/mason-nvim-dap.nvim',
	cmd = {'DapInstall', 'DapUninstall'},
	dependencies = {
		'williamboman/mason.nvim',
		'mfussenegger/nvim-dap'
	},
	opts = {
		ensure_installed = {'cppdbg', 'python'},
		handlers = require('plugins.debug.handlers').setup_handlers()
	}
}

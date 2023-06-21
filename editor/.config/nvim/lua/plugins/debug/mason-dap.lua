return {
	'jay-babu/mason-nvim-dap.nvim',
	dependencies = {
		'williamboman/mason.nvim',
		'mfussenegger/nvim-dap'
	},
	cmd = {'DapInstall', 'DapUninstall'},
	opts = {
		ensure_installed = {'cppdbg', 'python'},
		handlers = require('plugins.debug.handlers').setup_handlers()
	}
}

return {
	'williamboman/mason.nvim',
	build = function() pcall(vim.cmd, 'MasonUpdate') end,
	opts = {
		ui = {
			icons = {
				package_installed = '✓',
				package_pending = '➜',
				package_uninstalled = '✗'
			}
		}
	}
}

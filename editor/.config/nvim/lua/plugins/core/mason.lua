return {
	'williamboman/mason.nvim',
	build = function() pcall(vim.cmd, 'MasonUpdate') end,
	cmd = {
		'Mason',
		'MasonDebug',
		'MasonInstall',
		'MasonLog',
		'MasonUninstall',
		'MasonUninstallAll',
		'MasonUpdate'
	},
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

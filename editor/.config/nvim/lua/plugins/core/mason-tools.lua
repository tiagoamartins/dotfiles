return {
	'WhoIsSethDaniel/mason-tool-installer.nvim',
	cmd = {
		'MasonToolsClean',
		'MasonToolsInstall',
		'MasonToolsInstallSync',
		'MasonToolsUpdate',
		'MasonToolsUpdateSync'
	},
	dependencies = {
		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',
		'jay-babu/mason-nvim-dap.nvim'
	}
}

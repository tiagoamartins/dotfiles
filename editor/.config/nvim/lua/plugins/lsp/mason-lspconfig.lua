return {
	'williamboman/mason-lspconfig.nvim',
	cmd = {'LspInstall', 'LspUninstall'},
	dependencies = {
		'neovim/nvim-lspconfig',
		'williamboman/mason.nvim'
	},
	opts = {
		ensure_installed = {'clangd', 'pylsp'}
	}
}

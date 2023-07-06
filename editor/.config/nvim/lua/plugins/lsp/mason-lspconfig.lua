return {
	'williamboman/mason-lspconfig.nvim',
	lazy = true,
	dependencies = {
		'neovim/nvim-lspconfig',
		'williamboman/mason.nvim'
	},
	opts = {
		ensure_installed = {'clangd', 'pylsp'}
	}
}

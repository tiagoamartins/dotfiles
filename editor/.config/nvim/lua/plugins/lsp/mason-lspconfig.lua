return {
	'williamboman/mason-lspconfig.nvim',
	dependencies = {
		'neovim/nvim-lspconfig'
	},
	opts = {
		ensure_installed = {'clangd', 'pylsp'}
	}
}

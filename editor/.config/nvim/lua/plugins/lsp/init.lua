return {
	require('plugins.lsp.mason-lspconfig'),
	require('plugins.lsp.lspconfig'),

	-- formatters
	{
		'jay-babu/mason-null-ls.nvim',
		event = {'BufReadPre', 'BufNewFile'},
		dependencies = {
			"williamboman/mason.nvim",
			'jose-elias-alvarez/null-ls.nvim',
		},
		opts = {
			ensure_installed = {'ansible-lint', 'pylint', 'yamllint'},
			automatic_installation = false
		}
	},
	require('plugins.lsp.null-ls'),
	require('plugins.lsp.grammar-guard')
}

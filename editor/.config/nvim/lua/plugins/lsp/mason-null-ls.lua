return {
	'jay-babu/mason-null-ls.nvim',
	lazy = true,
	dependencies = {
		"williamboman/mason.nvim",
		'jose-elias-alvarez/null-ls.nvim',
	},
	opts = {
		ensure_installed = {'ansible-lint', 'pylint', 'yamllint'},
		automatic_installation = false
	}
}

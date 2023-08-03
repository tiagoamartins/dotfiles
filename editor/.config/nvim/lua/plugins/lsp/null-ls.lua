return {
	'jose-elias-alvarez/null-ls.nvim',
	event = {'BufReadPre', 'BufNewFile'},
	dependencies = {
		'jay-babu/mason-null-ls.nvim'
	},
	opts = function()
		local nls = require('null-ls')
		return {
			sources = {
				nls.builtins.diagnostics.ansiblelint,
				nls.builtins.diagnostics.pylint,
				nls.builtins.diagnostics.yamllint,
			},
			on_attach = function(client, bufnr)
				vim.api.nvim_buf_set_option(bufnr, 'formatexpr', '')
			end
		}
	end
}

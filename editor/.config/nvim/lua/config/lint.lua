local ok, null_ls = pcall(require, 'null-ls')

if not ok then
	return
end

null_ls.setup({
	sources = {
		null_ls.builtins.code_actions.gitsigns,
		null_ls.builtins.completion.luasnip,
		null_ls.builtins.completion.spell,
		null_ls.builtins.completion.tags,
		null_ls.builtins.diagnostics.ansiblelint,
		null_ls.builtins.diagnostics.buf,
		null_ls.builtins.diagnostics.flake8,
		null_ls.builtins.diagnostics.pycodestyle,
		null_ls.builtins.diagnostics.pydocstyle,
		null_ls.builtins.diagnostics.pylint,
		null_ls.builtins.diagnostics.verilator,
		null_ls.builtins.diagnostics.yamllint,
	},
	on_attach = function(client, bufnr)
		vim.api.nvim_buf_set_option(bufnr, 'formatexpr', '')
	end
})

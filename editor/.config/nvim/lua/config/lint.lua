-- local ok, nvim_lint = pcall(require, 'lint')
local ok, null_ls = pcall(require, 'null-ls')

if not ok then
	return
end

-- nvim_lint.linters_by_ft = {
-- 	yaml = {'ansible_lint', 'yamllint'}
-- }

-- vim.api.nvim_create_autocmd({"BufWritePost"}, {
-- 	callback = function()
-- 		nvim_lint.try_lint()
-- 	end,
-- })

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
		null_ls.builtins.diagnostics.yamllint,
	},
})

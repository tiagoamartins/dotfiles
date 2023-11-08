return {
	{
		'mfussenegger/nvim-lint',
		event = {'BufReadPre', 'BufNewFile'},
		config = function()
			local lint = require('lint')

			lint.linters_by_ft = {
				python = {'pylint'},
				yaml = {'ansible_lint', 'yamllint'}
			}

			local pysite = vim.fn.trim(vim.fn.system(
				'python3 -c "import site; print(site.getsitepackages()[0])"'
			))

			if pysite ~= nil then
				local pylint = lint.linters.pylint
				pylint.args = {
					'-f', 'json', '--init-hook',
					'import sys; sys.path.append(\'' .. pysite .. '\')'
				}
			end

			local lint_augroup = vim.api.nvim_create_augroup('lint', {clear = true})
			vim.api.nvim_create_autocmd({'BufEnter', 'BufWritePost', 'InsertLeave'}, {
				group = lint_augroup,
				callback = function()
					lint.try_lint()
				end
			})

			vim.keymap.set('n', '<leader>l', function()
				lint.try_lint()
			end, {desc = 'Run [L]int for current file'})
		end
	}
}

local ok, tscope = pcall(require, 'telescope')
if ok then
	tscope.setup()

	tscope.load_extension('find_pickers')

	local builtin = require('telescope.builtin')
	vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
	vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
	vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
	vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
	vim.keymap.set('n', '<leader>fp', tscope.extensions.find_pickers.find_pickers, {})
end

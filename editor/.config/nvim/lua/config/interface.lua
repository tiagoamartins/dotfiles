local ok, tscope = pcall(require, 'telescope')
if ok then
	tscope.setup()

	tscope.load_extension('find_pickers')
	tscope.load_extension('undo')

	local builtin = require('telescope.builtin')
	vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
	vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
	vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
	vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
	vim.keymap.set('n', '<leader>fp', tscope.extensions.find_pickers.find_pickers, {})
	vim.keymap.set('n', '<leader>fu', tscope.extensions.undo.undo, {})
end

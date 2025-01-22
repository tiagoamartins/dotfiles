return {
	'stevearc/oil.nvim',
	dependencies = {
		'echasnovski/mini.icons'
	},
	opts = {
		columns = {
			'icon'
		}
	},
	cmd = {'Oil'},
	keys = {
		{'<leader>o', function() require('oil').open(nil) end, desc = '[O]pen parent directory' },
	}
}

return {
	{
		'nvim-telescope/telescope.nvim',
		cmd = 'Telescope',
		config = function()
			tscope = require('telescope')
			tscope.setup()
			tscope.load_extension('find_pickers')
			tscope.load_extension('luasnip')
			tscope.load_extension('undo')
		end,
		version = '0.1.x',
		keys = {
			{'<leader>ff', '<cmd>Telescope find_files<cr>', desc = 'Find Files'},
			{'<leader>fg', '<cmd>Telescopelive_grep<cr>'},
			{'<leader>fb', '<cmd>Telescopebuffers<cr>'},
			{'<leader>fh', '<cmd>Telescopehelp_tags<cr>'},
			{'<leader>fp', '<cmd>Telescope find_pickers<cr>'},
			{'<leader>fs', '<cmd>Telescope luasnip<cr>'},
			{'<leader>fu', '<cmd>Telescope undo<cr>'},
		},
		dependencies = {
			'plenary.nvim',
			'nvim-telescope/telescope-fzf-native.nvim',
			'keyvchan/telescope-find-pickers.nvim',
			'debugloop/telescope-undo.nvim',
			'benfowler/telescope-luasnip.nvim',
			{
				'adoyle-h/lsp-toggle.nvim',
				opts = {
					create_cmds = true,
					telescope = true
				}
			},
		},
	},
	{
		'lewis6991/gitsigns.nvim',
		event = {'BufReadPre', 'BufNewFile'},
		config = function() require('gitsigns').setup() end,
		dependencies = {'plenary.nvim'},

	}
}

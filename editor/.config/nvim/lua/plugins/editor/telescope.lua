return {
	{
		'nvim-telescope/telescope.nvim',
		cmd = 'Telescope',
		config = function()
			tscope = require('telescope')
			tscope.setup()
			tscope.load_extension('find_pickers')
			tscope.load_extension('fzf')
			tscope.load_extension('luasnip')
			tscope.load_extension('undo')
		end,
		version = '0.1.x',
		keys = {
			{'<leader>?', function()
				require('telescope.builtin').oldfiles() end, desc =  '[?] Find recently opened files' },
			{'<leader><leader>', function() require('telescope.builtin').buffers() end, desc =  '[\\] Find existing buffers'},
			{'<leader>/', function()
				require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
					winblend = 10,
					previewer = false,
				}))
				end, desc =  '[/] Fuzzily search in current buffer'},
			{'<leader>gf', function() require('telescope.builtin').git_files() end, desc = 'Search [G]it [F]iles'},
			{'<leader>sf', function() require('telescope.builtin').find_files() end, desc = '[S]earch [F]iles'},
			{'<leader>sh', function() require('telescope.builtin').help_tags() end, desc = '[S]earch [H]elp'},
			{'<leader>sw', function() require('telescope.builtin').grep_string() end, desc = '[S]earch current [W]ord'},
			{'<leader>sg', function() require('telescope.builtin').live_grep() end, desc = '[S]earch by [G]rep'},
			{'<leader>sd', function() require('telescope.builtin').diagnostics() end, desc = '[S]earch [D]iagnostics'},
			{'<leader>sp', function() require('telescope').extensions.find_pickers.find_pickers() end, desc = '[S]earch [P]ickers'},
			{'<leader>ss', function() require('telescope').extensions.luasnip.luasnip() end, desc = '[S]earch [S]nippets'},
			{'<leader>su', function() require('telescope').extensions.undo.undo() end, desc = '[S]earch [U]ndo tree'},
		},
	},
	{
		'nvim-telescope/telescope-fzf-native.nvim',
		build = 'make',
		lazy = true,
		cond = function()
			return vim.fn.executable('make') == 1
		end,
	},
	{'keyvchan/telescope-find-pickers.nvim', lazy = true},
	{'debugloop/telescope-undo.nvim', lazy = true},
	{'benfowler/telescope-luasnip.nvim', lazy = true},
	{'nvim-telescope/telescope-smart-history.nvim', lazy = true},
	{'nvim-telescope/telescope-ui-select.nvim', lazy = true},
	{'kkharji/sqlite.lua', lazy = true},
	{
		'adoyle-h/lsp-toggle.nvim',
		lazy = true,
		opts = {
			create_cmds = true,
			telescope = true
		}
	}
}

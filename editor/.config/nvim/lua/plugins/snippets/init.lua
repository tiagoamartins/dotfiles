
return {
	{
		'L3MON4D3/LuaSnip',
		lazy = true,
		config = function()
			require('plugins.snippets.snippets').add_snippets()
		end,
		opts = {
			history = true,
			delete_check_events = 'TextChanged'
		},
		keys = {
			{'<leader>sl', function() return require('luasnip').choice_active() and '<Plug>luasnip-next-choice' end, expr = true, mode = {'i'}},
			{'<leader>sj', function() return require('luasnip').jumpable(1) and '<Plug>luasnip-jump' end, expr = true, mode = {'i'}},
			{'<leader>sk', function() require('luasnip').jump(-1) end, mode = {'i', 's'}},
			{'<leader>sj', function() require('luasnip').jump(1) end, mode = {'s'}}
		}
	}
}

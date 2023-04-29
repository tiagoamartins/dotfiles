
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
			{'<C-l>', function() return require('luasnip').choice_active() and '<Plug>luasnip-next-choice' or '<C-l>' end, expr = true, mode = {'i'}},
			{'<C-j>', function() return require('luasnip').jumpable(1) and '<Plug>luasnip-jump' or '<C-j>' end, expr = true, mode = {'i'}},
			{'<C-k>', function() require('luasnip').jump(-1) end, mode = {'i', 's'}},
			{'<C-j>', function() require('luasnip').jump(1) end, mode = {'s'}}
		}
	}
}

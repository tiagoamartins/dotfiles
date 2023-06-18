return {
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
		{'<C-l>', function()
			luasnip = require('luasnip')
			if luasnip.jumpable() then
				luasnip.jump(1)
			else
				return '<C-l>'
			end
			end, expr = true, mode = {'i', 's'}},
		{'<C-h>', function()
			luasnip = require('luasnip')
			if luasnip.jumpable() then
				luasnip.jump(-1)
			else
				return '<C-h>'
			end
			end, expr = true, mode = {'i', 's'}}
	}
}

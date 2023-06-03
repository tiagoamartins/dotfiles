
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
			{'<C-j>', function()
				luasnip = require('luasnip')
				if luasnip.jumpable() then
					luasnip.jump(1)
				else
					return '<C-j>'
				end
			end, expr = true, mode = {'i', 's'}},
			{'<C-k>', function()
				luasnip = require('luasnip')
				if luasnip.jumpable() then
					luasnip.jump(-1)
				else
					return '<C-k>'
				end
			end, expr = true, mode = {'i', 's'}}
		}
	}
}

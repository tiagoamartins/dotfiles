
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
		}
	}
}

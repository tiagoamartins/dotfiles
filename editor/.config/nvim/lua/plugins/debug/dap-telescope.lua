return {
	'nvim-telescope/telescope-dap.nvim',
	config = function() require('telescope').load_extension('dap') end,
	cond = function() return require('config.util').has('nvim-telescope') end
}

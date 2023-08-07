return {
	{
		'navarasu/onedark.nvim',
		priority = 1000,
		config = function(_, opts)
			require('onedark').setup(opts)
			vim.cmd.colorscheme 'onedark'
		end,
		opts = {style = 'warmer'}
	}
}

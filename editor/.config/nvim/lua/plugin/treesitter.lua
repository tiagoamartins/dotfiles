require'nvim-treesitter.configs'.setup{
	ensure_installed = {'bash', 'c', 'html', 'json', 'lua', 'python', 'rst'},
	highlight = {
		enable = true,
	},
	indent = {
		enable = true,
	},
}

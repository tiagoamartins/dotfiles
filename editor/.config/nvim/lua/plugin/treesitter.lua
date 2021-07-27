require'nvim-treesitter.configs'.setup{
	ensure_installed = {'bash', 'c', 'json', 'lua', 'python', 'rst'},
	highlight = {
		enable = true,
	},
	indent = {
		enable = true,
	},
}

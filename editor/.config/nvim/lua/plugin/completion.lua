local ok, cmp = pcall(require, 'cmp')

if not ok then
	return
end

local t = function(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
	local col = vim.fn.col('.') - 1
	return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

cmp.setup {
	mapping = {
	},
	snippet = {
	},
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'tags' },
		{ name = 'spell' },
		{ name = 'path' },
		{ name = 'buffer'},
	}
}

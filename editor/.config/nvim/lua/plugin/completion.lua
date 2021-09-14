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
		['<c-space>'] = cmp.mapping(function(fallback)
			if vim.fn.pumvisible() == 1 then
				if vim.fn['UltiSnips#CanExpandSnippet']() == 1 then
					return vim.fn.feedkeys(t('<c-r>=UltiSnips#ExpandSnippet()<cr>'))
				end

				vim.fn.feedkeys(t('<c-n>'), 'n')
			elseif check_back_space() then
				vim.fn.feedkeys(t('<cr>'), 'n')
			else
				fallback()
			end
		end, {'i', 's'}),
		['<tab>'] = cmp.mapping(function(fallback)
			if vim.fn.complete_info()['selected'] == -1 and vim.fn['UltiSnips#CanExpandSnippet']() == 1 then
				vim.fn.feedkeys(t('<c-r>=UltiSnips#ExpandSnippet()<cr>'))
			elseif vim.fn['UltiSnips#CanJumpForwards']() == 1 then
				vim.fn.feedkeys(t('<esc>:call UltiSnips#JumpForwards()<cr>'))
			elseif vim.fn.pumvisible() == 1 then
				vim.fn.feedkeys(t('<c-n>'), 'n')
			elseif check_back_space() then
				vim.fn.feedkeys(t('<tab>'), 'n')
			else
				fallback()
			end
		end, {'i', 's'}),
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if vim.fn['UltiSnips#CanJumpBackwards']() == 1 then
				return vim.fn.feedkeys(t('<c-r>=UltiSnips#JumpBackwards()<cr>'))
			elseif vim.fn.pumvisible() == 1 then
				vim.fn.feedkeys(t('<c-p>'), 'n')
			else
				fallback()
			end
		end, {'i', 's'}),
	},
	snippet = {
		expand = function(args)
			vim.fn['UltiSnips#Anon'](args.body)
		end,
	},
	sources = {
		{ name = 'ultisnips' },
		{ name = 'nvim_lsp' },
		{ name = 'tags' },
		{ name = 'spell' },
		{ name = 'path' },
		{ name = 'buffer'},
	}
}

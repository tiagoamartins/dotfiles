local ok, cmp = pcall(require, 'cmp')
if not ok then
	return
end

local config = {
	experimental = {
		ghost_text = true
	},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({select = false}),
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'nvim_lsp_signature_help' },
		{ name = 'nvim_lua' },
		{ name = 'luasnip' },
		{ name = 'treesitter' },
		{ name = 'tags' },
		{ name = 'path' },
	}, {
		{ name = 'buffer', keyword_length = 3 }
	}),
}

local ok, luasnip = pcall(require, 'luasnip')
if ok then
	config.snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end
	}
end

local ok, lspkind = pcall(require, 'lspkind')
if ok then
	config.formatting = {
		format = lspkind.cmp_format {
			mode = 'symbol_text',
			preset = 'codicons',
			maxwidth = 50,
			menu = {
				buffer = '[buf]',
				luasnip = '[snip]',
				nvim_lsp = '[lsp]',
				nvim_lua = '[api]',
				git = '[git]',
				path = '[path]',
				spell = '[spell]',
				tags = '[tags]'
			},
			before = function(entry, vim_item)
				local types = require('cmp.types')
				local str = require('cmp.utils.str')
				-- Get the full snippet (and only keep first line)
				local word = entry:get_insert_text()
				if entry.completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet then
					word = vim.lsp.util.parse_snippet(word)
				end
				word = str.oneline(word)
				if entry.completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet
						and string.sub(vim_item.abbr, -1, -1) == '~' then
					word = word .. '~'
				end
				vim_item.abbr = word

				return vim_item
			end,
		}
	}
end

local ok, cmpgit = pcall(require, 'cmp_git')
if ok then
	cmpgit.setup()

	cmp.setup.filetype('gitcommit', {
		sources = cmp.config.sources({
			{ name = 'git' },
		}, {
			{ name = 'buffer' },
		})
	})
end

cmp.setup(config)

cmp.setup.filetype('markdown', {
	sources = cmp.config.sources({
		{ name = 'pandoc_references' },
	}, {
		{ name = 'buffer' },
	})
})

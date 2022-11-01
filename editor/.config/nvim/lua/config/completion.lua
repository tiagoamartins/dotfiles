local ok, cmp = pcall(require, 'cmp')
if not ok then
	return
end

local config = {
	experimental = {
		ghost_text = true
	},
	mapping = {
		['<C-n>'] = cmp.mapping(
			cmp.mapping.select_next_item({
				behavior = cmp.SelectBehavior.Insert
			}),
			{'i', 'c'}
		),
		['<C-p>'] = cmp.mapping(
			cmp.mapping.select_prev_item({
				behavior = cmp.SelectBehavior.Insert
			}),
			{'i', 'c'}
		),
		['<C-,>'] = cmp.mapping(
			cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Insert,
				select = true
			}),
			{'i', 'c'}
		),
		['<C-Space>'] = cmp.mapping({
			i = cmp.mapping.complete(),
			c = function(
				_ --[[fallback]]
			)
				if cmp.visible() then
					if not cmp.confirm({select = true}) then
						return
					end
				else
					cmp.complete()
				end
			end
		}),
		['<C-y>'] = cmp.config.disable
	},
	sources = {
		{ name = 'luasnip' },
		{ name = 'nvim_lua' },
		{ name = 'nvim_lsp' },
		{ name = 'treesitter' },
		{ name = 'tags' },
		{ name = 'path' },
		{ name = 'buffer', keyword_length = 5 }
	}
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

cmp.setup(config)

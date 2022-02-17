local ok, cmp = pcall(require, 'cmp')
if not ok then
	return
end

local config = {
	experimental = {
		ghost_text = true,
		native_menu = false
	},
	mapping = {
		['<C-j>'] = cmp.mapping(
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
			}
		}
	}
end

cmp.setup(config)

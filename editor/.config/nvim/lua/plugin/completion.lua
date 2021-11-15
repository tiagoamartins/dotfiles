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
		{ name = 'nvim_lsp' },
		{ name = 'tags' },
		{ name = 'path' },
		{ name = 'buffer', keyword_length = 5 }
	}
}

cmp.setup(config)

return {
	{
		'saghen/blink.cmp',
		version = '*',
		opts = {
			keymap = {preset = 'default'},
			sources = {
				default = {
					'lsp',
					'path',
					'snippets',
					'buffer'
				},
				cmdline = {},
			},
			completion = {
				accept = {
					auto_brackets = {enabled = false},
				},
				menu = {
					draw = {
						columns = {
							{'label', 'label_description', gap = 1},
							{'kind_icon', 'kind'}
						},
						components = {
							kind_icon = {
								ellipsis = false,
								text = function(ctx)
									local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
									return kind_icon
								end,
								-- optionally, you may also use the highlights from mini.icons
								highlight = function(ctx)
									local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
									return hl
								end,
							}
						}
					}
				},
				-- show documentation when selecting a completion item
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 500
				},
				-- display a preview of the selected item on the current line
				ghost_text = {enabled = true},
			},
		},
		snippets = {
			preset = 'luasnip'
		},
		signature = {enabled = true},
		opts_extend = {'sources.default'}
	},
	{'echasnovski/mini.icons', lazy = true}
}

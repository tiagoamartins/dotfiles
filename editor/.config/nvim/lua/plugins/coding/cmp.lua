local function opts()
	local cmp = require('cmp')
	return {
		sources = {
			{name = 'nvim_lsp'},
			{name = 'nvim_lsp_signature_help'},
			{name = 'luasnip'},
			{name = 'path'},
			{name = 'tags'},
			{name = 'buffer'}
		},
		mapping = {
			['<C-n>'] = cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Insert}),
			['<C-p>'] = cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Insert}),
			['<C-y>'] = cmp.mapping(
				cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Insert,
					select = true,
				}),
				{'i', 'c'}
			),
		},
		snippet = {
			expand = function(args)
				vim.snippet.expand(args.body)
			end
		},
		window = {
			completion = cmp.config.window.bordered(),
			documentation = cmp.config.window.bordered(),
		}
	}
end

return {
	'hrsh7th/nvim-cmp',
	event = 'InsertEnter',
	lazy = true,
	dependencies = {
		'hrsh7th/cmp-buffer',
		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/cmp-nvim-lsp-signature-help',
		'hrsh7th/cmp-path',
		'onsails/lspkind.nvim',
		'saadparwaiz1/cmp_luasnip',
	},
	opts = opts
}

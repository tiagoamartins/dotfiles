return {
	{
		'hrsh7th/nvim-cmp',
		event = 'InsertEnter',
		lazy = true,
		dependencies = {
			'f3fora/cmp-spell',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-nvim-lua',
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-nvim-lsp-signature-help',
			'hrsh7th/cmp-path',
			'jc-doyle/cmp-pandoc-references',
			'onsails/lspkind-nvim',
			'petertriho/cmp-git',
			'quangnguyen30192/cmp-nvim-tags',
			'ray-x/cmp-treesitter',
			'saadparwaiz1/cmp_luasnip',
		},
		opts = require('plugins.coding.cmp').opts
	}
}

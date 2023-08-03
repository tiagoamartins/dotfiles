return {
	'brymer-meneses/grammar-guard.nvim',
	cond = function() return vim.fn.executable('ltex-ls') == 1 end,
	config = function(_, opts)
		require('grammar-guard').init()
		local nlsp = require('lspconfig')
		nlsp.grammar_guard.setup(opts)
	end,
	ft = {'bib', 'latex', 'markdown', 'rst', 'tex', 'text'},
	opts = {
		cmd = {'ltex-ls'},
		settings = {
			ltex = {
				enabled = {'latex', 'tex', 'bib', 'markdown'},
				language = 'en',
				diagnosticSeverity = 'information',
				setenceCacheSize = 2000,
				additionalRules = {
					enablePickyRules = true,
					motherTongue = 'en',
				},
				trace = {server = 'verbose'},
				dictionary = {},
			disabledRules = {en = {'EN_QUOTES', 'WORD_CONTAINS_UNDERSCORE'}},
				hiddenFalsePositives = {},
			}
		}
	}
}

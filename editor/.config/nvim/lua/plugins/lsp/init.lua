return {
	{
		'williamboman/mason-lspconfig.nvim',
		dependencies = {
			'neovim/nvim-lspconfig'
		},
		opts = {
			ensure_installed = {'clangd', 'pylsp'}
		}
	},
	require('plugins.lsp.lspconfig'),

	-- formatters
	{
		'jay-babu/mason-null-ls.nvim',
		event = {'BufReadPre', 'BufNewFile'},
		dependencies = {
			"williamboman/mason.nvim",
			'jose-elias-alvarez/null-ls.nvim',
		},
		opts = {
			ensure_installed = {'ansible-lint', 'pylint', 'yamllint'},
			automatic_installation = false
		}
	},
	{
		'jose-elias-alvarez/null-ls.nvim',
		event = {'BufReadPre', 'BufNewFile'},
		opts = function()
			local nls = require('null-ls')
			return {
				sources = {
					nls.builtins.diagnostics.ansiblelint,
					nls.builtins.diagnostics.pylint,
					nls.builtins.diagnostics.yamllint,
				},
				on_attach = function(client, bufnr)
					vim.api.nvim_buf_set_option(bufnr, 'formatexpr', '')
				end
			}
		end
	},
	{
		'brymer-meneses/grammar-guard.nvim',
		cond = function() return vim.fn.executable('ltex-ls') == 1 end,
		config = function(_, opts)
			require('grammar-guard').init()
			local nlsp = require('lspconfig')
			nlsp.grammar_guard.setup(opts)
		end,
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
					disabledRules = {en = {'EN_QUOTES'}},
					hiddenFalsePositives = {},
				}
			}
		}
	}
}

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
	{
		'neovim/nvim-lspconfig',
		event = {'BufReadPre', 'BufNewFile'},
		dependencies = {
			{
				'hrsh7th/cmp-nvim-lsp',
				cond = function() return require('config.util').has('nvim-cmp') end
			},
		},
		opts = {
			servers = {
				clangd = {},
				pylsp = {},
				svls = {
					root_dir = function() return vim.loop.cwd() end
				},
				verible = {
					cmd = {'verible-verilog-ls', '--rules_config_search=true'},
					root_dir = function() return vim.loop.cwd() end
				},
				veridian = {
					cmd = {'veridian'},
					filetypes = {'systemverilog', 'verilog'},
					root_dir = function(fname)
						local lsp_util = require('lspconfig.util')
						local lsp_cfgs = require('lspconfig.configs')
						local root_pattern = lsp_util.root_pattern('veridian.yml', '.git')
						local filename = lsp_util.path.is_absolute(fname) and fname
								 or lsp_util.path.join(vim.loop.cwd(), fname)
						return root_pattern(filename) or lsp_util.path.dirname(filename)
					end,
				}
			}
		},
		config = function(_, opts)
			local clsp = require('cmp_nvim_lsp')
			local keymaps = require('plugins.lsp.mappings')
			local servers = opts.servers
			local capabilities = vim.lsp.protocol.make_client_capabilities()

			keymaps.map()
			capabilities = clsp.default_capabilities(capabilities)

			for server, server_opts in pairs(servers) do
				local cmd = ''

				if server_opts.cmd then
					cmd = server_opts.cmd[1]
				else
					cmd = server
				end


				if vim.fn.executable(cmd) == 1 then
					local s_opts = vim.tbl_deep_extend('force', {
						capabilities = vim.deepcopy(capabilities),
						on_attach = keymaps.on_attach
					}, server_opts or {})
					require('lspconfig')[server].setup(s_opts)
				end
			end
		end
	},

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

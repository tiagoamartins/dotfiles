return {
	'neovim/nvim-lspconfig',
	event = {'BufReadPre', 'BufNewFile'},
	dependencies = {
		'hrsh7th/cmp-nvim-lsp',
		'williamboman/mason-lspconfig.nvim'
	},
	opts = {
		servers = {
			bashls = {},
			clangd = {},
			jsonls = {},
			ltex = {
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
			},
			ruff_lsp = {},
			svls = {
				cmd_match = true,
				root_dir = function() return vim.loop.cwd() end
			},
			svlangserver = {},
		}
	},
	config = function(_, opts)
		local mason_servers = {}
		local other_servers = {}

		for name, server in pairs(opts.servers) do
			if server.mason == nil or server.mason then
				table.insert(mason_servers, name)
			else
				table.insert(other_servers, name)
			end
		end

		require('plugins.lsp.mappings').map()

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

		function register_lsp(server_name)
			local server = opts.servers[server_name] or {}
			local cmd = (server.cmd or {})[1] or server_name
			local skip_match = server.cmd_match == nil or not server.cmd_match

			if vim.fn.executable(cmd) == 1 or skip_match then
				server['capabilities'] = capabilities
				require('lspconfig')[server_name].setup(server)
			end
		end

		for _, name in ipairs(other_servers) do
			register_lsp(name)
		end

		require('mason-lspconfig').setup({
			ensure_installed = mason_servers,
			handlers = {register_lsp}
		})
	end
}

return {
	'neovim/nvim-lspconfig',
	event = {'BufReadPre', 'BufNewFile'},
	dependencies = {
		'hrsh7th/cmp-nvim-lsp',
		'williamboman/mason-lspconfig.nvim'
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
		local mason_lsp = require('mason-lspconfig')
		local servers = opts.servers
		local capabilities = vim.lsp.protocol.make_client_capabilities()

		keymaps.map()
		capabilities = clsp.default_capabilities(capabilities)
		mason_lsp.setup({
			ensure_installed = vim.tbl_keys(servers)
		})

		mason_lsp.setup_handlers({
			function(server_name)
				local cmd = ((servers[server_name] or {}).cmd or {})[1] or server_name
				if vim.fn.executable(cmd) == 1 then
					require('lspconfig')[server_name].setup({
						capabilities = capabilities,
						on_attach = keymaps.on_attach,
						settings = servers[server_name],
						filetypes = (servers[server_name] or {}).filetypes
					})
				end
			end
		})
	end
}

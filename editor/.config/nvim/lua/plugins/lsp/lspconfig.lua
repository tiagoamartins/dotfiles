return {
	'neovim/nvim-lspconfig',
	event = {'BufReadPre', 'BufNewFile'},
	dependencies = {
		'hrsh7th/cmp-nvim-lsp',
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
}

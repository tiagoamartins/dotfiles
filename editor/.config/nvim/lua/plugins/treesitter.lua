return {
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		event = {'BufReadPost', 'BufNewFile'},
		dependencies = {
			'JoosepAlviste/nvim-ts-context-commentstring',
			'nvim-treesitter/nvim-treesitter-context',
			'nvim-treesitter/nvim-treesitter-refactor',
			{
				'nvim-treesitter/nvim-treesitter-textobjects',
				init = function()
					-- PERF: no need to load the plugin, if we only need its queries for mini.ai
					local plugin = require("lazy.core.config").spec.plugins["nvim-treesitter"]
					local opts = require("lazy.core.plugin").values(plugin, "opts", false)
					local enabled = false
					if opts.textobjects then
						for _, mod in ipairs({ "move", "select", "swap", "lsp_interop" }) do
							if opts.textobjects[mod] and opts.textobjects[mod].enable then
								enabled = true
								break
							end
						end
					end
					if not enabled then
						require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
					end
				end
			},
		},
		opts = {
			ensure_installed = {
				'bash',
				'c',
				'cpp',
				'comment',
				'html',
				'json',
				'lua',
				'markdown',
				'python',
				'rst',
				'verilog',
				'vim'
			},
			context_commentstring = {
				enable = true,
			},
			highlight = {
				enable = true,
				disable = {'verilog'},
				additional_vim_regex_highlighting = true
			},
			incremental_selection = {
				enable = true,
			},
			indent = {
				enable = true,
				disable = {'c', 'python'}
			},
			refactor = {
				highlight_definitions = { enable = true },
				navigation = {
					enable = true,
					keymaps = {
						goto_definition_lsp_fallback = "<leader>gd",
						goto_next_usage = "<leader>]d",
						goto_previous_usage = "<leader>[d",

					}
				}
			},
			rainbow = {
				enable = true,
				extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
				max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
			}
		},
		config = function(_, opts)
			require('treesitter-context').setup({enable = true})
			require('nvim-treesitter.configs').setup(opts)
		end
	}
}

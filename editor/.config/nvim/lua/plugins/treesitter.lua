return {
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		event = {'BufReadPost', 'BufNewFile'},
		dependencies = {
			'JoosepAlviste/nvim-ts-context-commentstring',
			'nvim-treesitter/nvim-treesitter-context',
			{
				'nvim-treesitter/nvim-treesitter-textobjects',
				init = function()
					-- PERF: no need to load the plugin, if we only need its queries for mini.ai
					local plugin = require('lazy.core.config').spec.plugins['nvim-treesitter']
					local opts = require('lazy.core.plugin').values(plugin, 'opts', false)
					local enabled = false
					if opts.textobjects then
						for _, mod in ipairs({'move', 'select', 'swap', 'lsp_interop'}) do
							if opts.textobjects[mod] and opts.textobjects[mod].enable then
								enabled = true
								break
							end
						end
					end
					if not enabled then
						require('lazy.core.loader').disable_rtp_plugin('nvim-treesitter-textobjects')
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
				'vim',
				'vimdoc'
			},
			highlight = {enable = true},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = '<C-Space>',
					node_incremental = '<C-Space>',
					node_decremental = '<M-Backspace>',
					scope_incremental = '<C-s>'
				}
			},
			indent = {enable = true},
			textobjects = {
				select = {
					enable = true,
					lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
					keymaps = {
						['aa'] = '@parameter.outer',
						['ia'] = '@parameter.inner',
						['af'] = '@function.outer',
						['if'] = '@function.inner',
						['ac'] = '@class.outer',
						['ic'] = '@class.inner',
					},
				},
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						[']m'] = '@function.outer',
						[']]'] = '@class.outer',
					},
					goto_next_end = {
						[']M'] = '@function.outer',
						[']['] = '@class.outer',
					},
					goto_previous_start = {
						['[m'] = '@function.outer',
						['[['] = '@class.outer',
					},
					goto_previous_end = {
						['[M'] = '@function.outer',
						['[]'] = '@class.outer',
					},
				},
				swap = {
					enable = true,
					swap_next = {
						['<leader>a'] = '@parameter.inner',
					},
					swap_previous = {
						['<leader>A'] = '@parameter.inner',
					},
				},
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

local ok, treesitter = pcall(require, 'nvim-treesitter.configs')

if not ok then
	return
end

treesitter.setup{
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
		disable = {'verilog'}
	},
	incremental_selection = {
		enable = true,
	},
	indent = {
		enable = true,
		disable = {'c', 'python'}
	},
	textobjects = {
		select = {
			enable = true,
			keymaps = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			},
		},
		swap = {
			enable = true,
			swap_next = {
				["<leader>a"] = "@parameter.inner",
			},
			swap_previous = {
				["<leader>A"] = "@parameter.inner",
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]m"] = "@function.outer",
				["]]"] = "@class.outer",
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[["] = "@class.outer",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[]"] = "@class.outer",
			},
		},
		lsp_interop = {
			enable = true,
			peek_definition_code = {
				["<leader>df"] = "@function.outer",
				["<leader>dF"] = "@class.outer",
			},
		},
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
}

local ok, treesitter_context = pcall(require, 'treesitter-context.config')

if not ok then
	return
end

treesitter_context.setup{
	enable = true,
}

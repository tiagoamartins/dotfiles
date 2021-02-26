vim.g.completion_sorting = 'length'
vim.g.completion_matching_strategy_list = {'exact', 'substring', 'fuzzy'}

-- use ultisnips for snippet completion source
vim.g.completion_enable_snippet = 'UltiSnips'

-- configure the completion chains
vim.g.completion_chain_complete_list = {
	default = {
		default = {
			{complete_items = {'lsp', 'snippet'}},
			{mode = 'user'}
		},
		comment = nil,
		string = nil
	},
	vim = {
		{complete_items = {'snippet'}},
	},
	bash = {
		{complete_items = {'ts'}}
	},
	c = {
		{complete_items = {'ts'}}
	},
	python = {
		{complete_items = {'lsp'}}
	},
	lua = {
		{complete_items = {'ts'}}
	},
	rst = {
		{complete_items = {'ts'}}
	},
	json = {
		{complete_items = {'ts'}}
	},
	verilog = {
		{complete_items = {'ts'}}
	},
}

-- use completion-nvim in every buffer
vim.api.nvim_exec([[
	autocmd BufEnter * lua require'completion'.on_attach()
]], false)

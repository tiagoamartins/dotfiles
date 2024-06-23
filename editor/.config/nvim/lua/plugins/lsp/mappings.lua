local M = {}

function M.map()
	vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, {desc = 'Go to previous diagnostic message'})
	vim.keymap.set('n', ']d', vim.diagnostic.goto_next, {desc = 'Go to next diagnostic message'})
	vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, {desc = 'Open floating diagnostic message'})
	vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, {desc = 'Open diagnostic list'})

	vim.api.nvim_create_autocmd('LspAttach', {
		group = vim.api.nvim_create_augroup('UserLspConfig', {}),
		callback = M.on_attach
	})
end

function M.on_attach(args)
	local bufnr = args.buf

	function nmap(keys, func, desc)
		if (desc) then
			desc = 'LSP: ' .. desc
		end

		vim.keymap.set('n', keys, func, {buffer = bufnr, desc = desc})
	end

	local telescope = require('telescope.builtin')

	vim.opt_local.omnifunc = 'v:lua.vim.lsp.omnifunc'

	-- mappings
	nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
	nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

	nmap('gd', vim.lsp.buf.definition, '[G]o to [D]efinition')
	nmap('gr', telescope.lsp_references, '[G]o to [R]eferences')
	nmap('gI', vim.lsp.buf.implementation, '[G]o to [I]mplementation')
	nmap('gT', vim.lsp.buf.type_definition, '[G]o to [T]ype')
	nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
	nmap('<leader>ds', telescope.lsp_document_symbols, '[D]ocument [S]ymbols')
	nmap('<leader>ws', telescope.lsp_workspace_symbols, '[W]orkspace [S]ymbols')

	nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
	nmap('<leader>k', vim.lsp.buf.signature_help, 'Signature Documentation')

	nmap('gD', vim.lsp.buf.declaration, '[G]o to [D]eclaration')
	nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
	nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
	nmap('<leader>wl', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, '[W]orkspace [L]ist Folders')

	vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
		vim.lsp.buf.format()
	end, {desc = 'Format current buffer with LSP'})
end

return M

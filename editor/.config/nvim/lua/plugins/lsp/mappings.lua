local M = {}

function M.on_attach(client, bufnr)
	local function buf_map(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
	local function buf_opt(...) vim.api.nvim_buf_set_option(bufnr, ...) end

	buf_opt('omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- mappings
	local opts = {noremap=true, silent=true}
	buf_map('n', '<leader>S', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
	buf_map('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
	buf_map('n', '<C-]>', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
	buf_map('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
	buf_map('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<cr>', opts)
	buf_map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
	buf_map('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>', opts)
	buf_map('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>', opts)
	buf_map('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>', opts)
	buf_map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
	buf_map('n', '<leader>[D', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
	buf_map('n', '<leader>]D', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)
	buf_map('n', '<leader>gD', '<Cmd>lua vim.lsp.buf.declaration()<cr>', opts)
	buf_map('n', '<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
	buf_map('n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
	buf_map('n', '<leader>a', '<cmd>lua vim.lsp.bud.code_action()<cr>', opts)

	-- set some keybinds conditional on server capabilities
	if client.server_capabilities.document_formatting then
		buf_map('n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<cr>', opts)
	elseif client.server_capabilities.document_range_formatting then
		buf_map('n', '<leader>f', '<cmd>lua vim.lsp.buf.range_formatting()<cr>', opts)
	end

	-- set autocommands conditional on server_capabilities
	if client.server_capabilities.document_highlight then
		vim.api.nvim_exec([[
			hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
			hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
			hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
			augroup lsp_document_highlight
			autocmd! * <buffer>
			autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
			autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
			augroup END
		]], false)
	end
end

return M

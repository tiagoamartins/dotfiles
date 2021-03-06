local nvim_lsp = require('lspconfig')

local function on_attach(client, bufnr)
	local function buf_map(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
	local function buf_opt(...) vim.api.nvim_buf_set_option(bufnr, ...) end

	buf_opt('omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- mappings
	local opts = {noremap=true, silent=true}
	buf_map('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	buf_map('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
	buf_map('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
	buf_map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	buf_map('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	buf_map('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
	buf_map('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
	buf_map('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
	buf_map('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	buf_map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	buf_map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	buf_map('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
	buf_map('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
	buf_map('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
	buf_map('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

	-- set some keybinds conditional on server capabilities
	if client.resolved_capabilities.document_formatting then
		buf_map('n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
	elseif client.resolved_capabilities.document_range_formatting then
		buf_map('n', '<leader>f', '<cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
	end

	-- set autocommands conditional on server_capabilities
	if client.resolved_capabilities.document_highlight then
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

-- use a loop to conveniently both setup defined servers
-- and map buffer local keybindings when the language server attaches
local servers = {'pyls', 'clangd'}
for _, lsp in ipairs(servers) do
	nvim_lsp[lsp].setup{on_attach = on_attach}
end

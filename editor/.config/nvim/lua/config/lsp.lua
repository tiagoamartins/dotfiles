local ok, nvim_lsp = pcall(require, 'lspconfig')

if not ok then
	return
end

local function on_attach(client, bufnr)
	local function buf_map(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
	local function buf_opt(...) vim.api.nvim_buf_set_option(bufnr, ...) end

	buf_opt('omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- mappings
	local opts = {noremap=true, silent=true}
	buf_map('n', '<leader>S', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	buf_map('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	buf_map('n', '<C-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
	buf_map('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
	buf_map('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
	buf_map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	buf_map('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
	buf_map('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
	buf_map('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
	buf_map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
	buf_map('n', '<leader>[D', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
	buf_map('n', '<leader>]D', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
	buf_map('n', '<leader>gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	buf_map('n', '<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	buf_map('n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	buf_map('n', '<leader>a', '<cmd>lua vim.lsp.bud.code_action()<CR>', opts)

	-- set some keybinds conditional on server capabilities
	if client.server_capabilities.document_formatting then
		buf_map('n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
	elseif client.server_capabilities.document_range_formatting then
		buf_map('n', '<leader>f', '<cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
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

local ok, cmp_lsp = pcall(require, 'cmp_nvim_lsp')

if ok then
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = cmp_lsp.default_capabilities(capabilities)
else
	local capabilities = {}
end

-- use a loop to conveniently both setup defined servers
-- and map buffer local keybindings when the language server attaches
local servers = {
	['clangd'] = {},
	['pylsp'] = {},
	['svls'] = {
		root_dir = function() return vim.loop.cwd() end
	},
	['verible'] = {
		cmd = {'verible-verilog-ls', '--rules_config_search=true'},
		root_dir = function() return vim.loop.cwd() end
	}
}

for lsp, cfg in pairs(servers) do
	local cmd = ''

	if cfg.cmd then
		cmd = cfg.cmd[1]
	else
		cmd = lsp
	end


	if vim.fn.executable(cmd) == 1 then
		local lsp_cfg = {
			capabilities = capabilities,
			on_attach = on_attach,
		}

		for k, v in pairs(cfg) do
			lsp_cfg[k] = v
		end

		nvim_lsp[lsp].setup(lsp_cfg)
	end
end

local ok, gitsigns = pcall(require, 'gitsigns')
if ok then
	gitsigns.setup()
end

local ok, lspsig = pcall(require, 'lsp_signature')
if ok then
	lspsig.setup()
end

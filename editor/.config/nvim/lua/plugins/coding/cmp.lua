local M = {}

function M.opts()
	local cmp = require('cmp')
	local luasnip = require('luasnip')
	local lspkind = require('lspkind')
	return {
		experimental = {
			ghost_text = {enabled = true}
		},
		mapping = cmp.mapping.preset.insert({
			['<C-b>'] = cmp.mapping.scroll_docs(-4),
			['<C-f>'] = cmp.mapping.scroll_docs(4),
			['<C-Space>'] = cmp.mapping.complete(),
			['<C-e>'] = cmp.mapping.abort(),
			['<cr>'] = cmp.mapping({
				i = function (fallback)
					if cmp.visible() and cmp.get_active_entry() then
						cmp.confirm({behavior = cmp.ConfirmBehavior.Replace, select = false})
					else
						fallback()
					end
				end,
				s = cmp.mapping.confirm({select = true}),
				c = cmp.mapping.confirm({behavior = cmp.ConfirmBehavior.Replace, select = true})
			}),
			['<tab>'] = cmp.mapping(function (fallback)
				if cmp.visible() then
					cmp.select_next_item()
				elseif luasnip.expand_or_locally_jumpable() then
					luasnip.expand_or_jump()
				else
					fallback()
				end
			end, {'i', 's'}),
			['<s-tab>'] = cmp.mapping(function (fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif luasnip.jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end, {'i', 's'}),
		}),
		sources = cmp.config.sources({
			{name = 'luasnip'},
			{name = 'nvim_lsp'},
			{name = 'nvim_lsp_signature_help'},
			{name = 'nvim_lua'},
			{name = 'treesitter'},
			{name = 'tags'},
			{name = 'path'},
		}, {
			{name = 'buffer', keyword_length = 3}
		}),
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end
		},
		formatting = {
			format = lspkind.cmp_format {
				mode = 'symbol_text',
				preset = 'codicons',
				maxwidth = 50,
				menu = {
					buffer = '[buf]',
					luasnip = '[snip]',
					nvim_lsp = '[lsp]',
					nvim_lua = '[api]',
					git = '[git]',
					path = '[path]',
					spell = '[spell]',
					tags = '[tags]'
				},
				before = function(entry, vim_item)
					local types = require('cmp.types')
					local str = require('cmp.utils.str')
					-- Get the full snippet (and only keep first line)
					local word = entry:get_insert_text()
					if entry.completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet then
						word = vim.lsp.util.parse_snippet(word)
					end
					word = str.oneline(word)
					if entry.completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet
						and string.sub(vim_item.abbr, -1, -1) == '~' then
						word = word .. '~'
					end
					vim_item.abbr = word

					return vim_item
				end,
			}
		},
		filetype = {
			gitcommit = {
				sources = cmp.config.sources({
					{name = 'git'},
				}, {
					{name = 'buffer'},
				})
			},
			markdown = {
				sources = cmp.config.sources({
					{name = 'pandoc_references'},
				}, {
					{name = 'buffer'},
				})
			}
		}
	}
end

return M

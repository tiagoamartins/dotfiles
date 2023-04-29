local M = {}

local function file_begin()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	return row == 1 and col == 1
end

function M.add_snippets()
	local luasnip = require('luasnip')

	local s = luasnip.snippet
	local t = luasnip.text_node
	local i = luasnip.insert_node
	local r = luasnip.restore_node
	local d = luasnip.dynamic_node
	local sn = luasnip.snippet_node
	local fmt = require('luasnip.extras.fmt').fmt
	local rep = require('luasnip.extras').rep

	luasnip.add_snippets('all', {
		s('#', fmt('#!/usr/bin/env {}\n{}', {
			d(1, function (args)
				return sn(nil, i(1, vim.bo.filetype))
			end, {}),
			i(0)
		}), {
			condition = file_begin,
			show_condition = file_begin
		})
	})

	luasnip.add_snippets('c', {
		s('#i', {
			t('#ifndef '),
			d(1, function (args)
				filename = vim.fn.expand('%')
				filename = filename:gsub('%.', '_')

				return sn(nil, i(1, '__' .. string.upper(filename) .. '__'))
			end, {}),
			t({'', '#define '}),
			rep(1),
			t({'', '', ''}),
			i(0),
			t({'', '', '#endif'})
		})
	})
end

return M

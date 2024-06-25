require('luasnip.session.snippet_collection').clear_snippets('all')

local ls = require('luasnip')

local s = ls.snippet
local i = ls.insert_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local fmt = require('luasnip.extras.fmt').fmt


local function file_begin()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	return row == 1 and col == 1
end

ls.add_snippets('all', {
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

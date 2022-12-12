local ok, luasnip = pcall(require, 'luasnip')
if not ok then
	return
end

local s = luasnip.snippet
local t = luasnip.text_node
local i = luasnip.insert_node
local r = luasnip.restore_node
local d = luasnip.dynamic_node
local sn = luasnip.snippet_node
local fmt = require('luasnip.extras.fmt').fmt
local rep = require('luasnip.extras').rep

luasnip.config.set_config({
	history = true,
	updateevents = 'TextChanged,TextChangedI',
})

local function file_begin()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	return row == 1 and col == 1
end

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

local function map(...) vim.api.nvim_set_keymap(...) end

s_expr = {expr = true, silent = true}
s_noremap = {noremap = true, silent = true}

map('i', '<C-l>', [[luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-l>']], s_expr)
map('i', '<C-j>', [[luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<C-j>']], s_expr)
map('i', '<C-k>', [[<cmd>lua require('luasnip').jump(-1)<cr>]], s_noremap)
map('s', '<C-j>', [[<cmd>lua require('luasnip').jump(1)<cr>]], s_noremap)
map('s', '<C-k>', [[<cmd>lua require('luasnip').jump(-1)<cr>]], s_noremap)

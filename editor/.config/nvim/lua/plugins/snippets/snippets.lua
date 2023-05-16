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

	luasnip.add_snippets('verilog', {
		s('ff', fmt([[
				always @({7} {1}) begin
					if ({6}) begin
						{4} <= {5};
					end else begin
						{2} <= {3};
					end
				end
			]], {
				i(1, 'clk_i'),
				i(2, 'sig'),
				i(3, '1\'b1'),
				rep(2),
				i(4, '1\'b0'),
				i(5, '!rstn_i'),
				i(6, 'posedge')
			})
		)
	})

	luasnip.add_snippets('systemverilog', {
		s('cmb', fmt([[
				always_comb begin
					{}
				end
			]], {i(0)})
		),
		s('ff', fmt([[
				always_ff @({7} {1}) begin
					if ({6}) begin
						{4} <= {5};
					end else begin
						{2} <= {3};
					end
				end
			]], {
				i(1, 'clk_i'),
				i(2, 'sig'),
				i(3, '1\'b1'),
				rep(2),
				i(4, '1\'b0'),
				i(5, '!rstn_i'),
				i(6, 'posedge')
			})
		)
	})

	luasnip.filetype_extend('systemverilog', {'verilog'})
end

return M

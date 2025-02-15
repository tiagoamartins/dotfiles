require('luasnip.session.snippet_collection').clear_snippets('systemverilog')

local ls = require('luasnip')

local s = ls.snippet
local i = ls.insert_node
local fmt = require('luasnip.extras.fmt').fmt
local rep = require('luasnip.extras').rep

ls.add_snippets('systemverilog', {
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

ls.filetype_extend('systemverilog', {'verilog'})

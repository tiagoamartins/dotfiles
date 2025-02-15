require('luasnip.session.snippet_collection').clear_snippets('c')

local ls = require('luasnip')

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local rep = require('luasnip.extras').rep

ls.add_snippets('c', {
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

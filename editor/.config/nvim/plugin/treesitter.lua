vim.pack.add({
    {
        src = 'https://github.com/nvim-treesitter/nvim-treesitter',
        version = 'main',
    },
})

require('nvim-treesitter').setup()

require('nvim-treesitter-textobjects').setup({
    select = {
        lookahead = true, -- jump forward to textobj, similar to targets.vim
    },
    move = {
        set_jumps = true, -- whether to set jumps in the jumplist
    },
})

local ts_select = function(query)
    return function()
        require('nvim-treesitter-textobjects.select').select_textobject(query, 'textobjects')
    end
end

local ts_move = function(fn, query)
    return function()
        require('nvim-treesitter-textobjects.move')[fn](query, 'textobjects')
    end
end

local ts_swap = function(fn, query)
    return function()
        require('nvim-treesitter-textobjects.swap')[fn](query)
    end
end

for lhs, query in pairs({
    ['aa'] = '@parameter.outer',
    ['ia'] = '@parameter.inner',
    ['af'] = '@function.outer',
    ['if'] = '@function.inner',
    ['ac'] = '@class.outer',
    ['ic'] = '@class.inner',
}) do
    vim.keymap.set({'x', 'o'}, lhs, ts_select(query), {desc = 'TS select ' .. query})
end

for fn, maps in pairs({
    goto_next_start = {[']m'] = '@function.outer', [']]'] = '@class.outer'},
    goto_next_end = {[']M'] = '@function.outer', [']['] = '@class.outer'},
    goto_previous_start = {['[m'] = '@function.outer', ['[['] = '@class.outer'},
    goto_previous_end = {['[M'] = '@function.outer', ['[]'] = '@class.outer'},
}) do
    for lhs, query in pairs(maps) do
        vim.keymap.set({'n', 'x', 'o'}, lhs, ts_move(fn, query), {desc = 'TS ' .. fn .. ' ' .. query})
    end
end

vim.keymap.set('n', '<leader>a]', ts_swap('swap_next', '@parameter.inner'), {desc = 'TS swap next parameter'})
vim.keymap.set('n', '<leader>a[', ts_swap('swap_previous', '@parameter.inner'), {desc = 'TS swap previous parameter'})

local parsers = require('config.treesitter').get_parsers()
require('nvim-treesitter').install(parsers)
require('treesitter-context').setup({enable = true})
require('ts_context_commentstring').setup({enable_autocmd = false})

local get_option = vim.filetype.get_option
---@diagnostic disable-next-line: duplicate-set-field
vim.filetype.get_option = function(filetype, option)
    if option == 'commentstring' then
        local cs = require('ts_context_commentstring.internal').calculate_commentstring()
        if cs then
            return cs
        end
    end
    return get_option(filetype, option)
end

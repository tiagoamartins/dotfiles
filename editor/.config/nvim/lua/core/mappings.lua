local mappings = {}

-- register an internal keymap that wraps `fn` with vim-repeat
local make_repeatable_keymap = function(mode, map, fn)
   vim.validate('mode', mode, {'string', 'table'})
   vim.validate('fn', fn, 'function')
   vim.validate('map', map,  'string')

   if not vim.startswith(map, '<plug>') then
      error('`map` should start with `<plug>`, given: ' .. map)
   end

   vim.keymap.set(mode, map, function()
      fn()
      vim.fn['repeat#set'](vim.api.nvim_replace_termcodes(map, true, true, true))
   end)

   return map
end

-- normal {{{1
mappings.n = {
    -- leader {{{2
    -- window swap
    win_swap_mark = {
        keys = '<leader>wm',
        exec = require('core.window').mark_swap,
        silent = true,
    },
    win_swap_do = {
        keys = '<leader>wp',
        exec = require('core.window').do_swap,
        silent = true,
    },

    -- turn off search highlight
    clear_highlight = {
        keys = '<leader><space>',
        exec = vim.cmd.nohlsearch,
    },

    -- remove trailing space
    trim_trail = {
        keys = '<leader>$',
        exec = function()
            require('core.cursor').preserve('%s/\\s\\+$//e')
        end,
    },

    -- indent entire file
    file_indent = {
        keys = '<leader>=',
        exec = function()
            require('core.cursor').preserve('normal gg=G')
        end,
    },

    -- edit vimrc
    cfg_edit = {
        keys = '<leader>ev',
        exec = function()
            vim.cmd.vsplit(vim.env.MYVIMRC)
        end,
    },
    -- load vimrc
    cfg_reload = {
        keys = '<leader>sv',
        exec = function()
            vim.cmd.source(vim.env.MYVIMRC)
        end,
    },

    -- call fugitive
    git = {
        keys = '<leader>git',
        exec = vim.cmd.Git,
    },

    -- change spelling language
    spell_en = {
        keys = '<leader>en',
        exec = function()
            vim.opt.spelllang=en_us
        end,
        silent = true,
    },
    spell_pt = {
        keys = '<leader>pt',
        exec = function()
            vim.opt.spelllang=pt_br
        end,
        silent = true,
    },

    -- tests {{{3
    test_near = {
        keys = '<leader>tn',
        exec = vim.cmd.TestNearest,
        silent = true,
        remap = true,
    },
    test_file = {
        keys = '<leader>tf',
        exec = vim.cmd.TestFile,
        silent = true,
        remap = true,
    },
    test_suite = {
        keys = '<leader>ts',
        exec = vim.cmd.TestSuite,
        silent = true,
        remap = true,
    },
    test_last = {
        keys = '<leader>tl',
        exec = vim.cmd.TestLast,
        silent = true,
        remap = true,
    },
    test_visit = {
        keys = '<leader>tv',
        exec = vim.cmd.TestVisit,
        silent = true,
        remap = true,
    },

    -- tabularize {{{3
    table_assign = {
        keys = '<leader>a=',
        exec = function()
            vim.cmd.Tabularize('/^[^<=]*\\zs<=')
        end,
        buffer = true,
    },
    table_range = {
        keys = '<leader>a:',
        exec = function()
            vim.cmd.Tabularize('/^[^:]*\\zs:')
        end,
        buffer = true,
    },

    -- function keys {{{2
    -- toggle spelling
    spell_toggle = {
        keys = '<f4>',
        exec = function()
            vim.opt.spell = not vim.opt.spell:get()
            vim.print('spell check: ' .. (vim.opt.spell:get() and 'on' or 'off'))
        end,
    },

    dispatch = {
        keys = '<f9>',
        exec = vim.cmd.Dispatch,
    },
    build = {
        keys = '<f10>',
        exec = vim.cmd.Mbuild,
    },

    -- set space to toggle a fold
    fold = {
        keys = '<space>',
        exec = 'za',
    },

    -- swap two characters with capability of repeat by '.' (using repeat plugin)
    swap_chars = {
        keys = 'cp',
        exec = make_repeatable_keymap(
            {'n', 'c'},
            '<plug>TransposeChars', function()
                vim.cmd.normal('xph')
            end),
        remap = true,
    },

    -- highlight last inserted text
    highlight_last = {
        keys = 'gV',
        exec = '`[v`]',
    },
}

-- visual {{{1
mappings.v = {
    -- replace without loosing current yank
    paste_wo_replace = {
        keys = '<leader>p',
        exec = '"_dp',
    },
    paste_before_wo_replace = {
        keys = '<leader>P',
        exec = '"_dP',
    },

    table_assign = {
        keys = '<leader>a=',
        exec = function()
            vim.cmd.Tabularize('/^[^<=]*\\zs<=')
        end,
        buffer = true,
    },
    table_range = {
        keys = '<leader>a:',
        exec = function()
            vim.cmd.Tabularize('/^[^:]*\\zs:')
        end,
        buffer = true,
    },
}

-- setup {{{1
for mode, maps in pairs(mappings) do
    for _, opts in pairs(maps) do
        local lhs = opts.keys
        local rhs = opts.exec

        opts.keys = nil
        opts.exec = nil
        vim.keymap.set(mode, lhs, rhs, opts)
    end
end

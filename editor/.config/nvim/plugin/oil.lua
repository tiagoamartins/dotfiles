vim.pack.add({'https://github.com/stevearc/oil.nvim'})

require('oil').setup({
    columns = {
        {'icon', add_padding = false}
    },
    float = {
        max_width = 0.85,
        max_height = 0.85,
    },
    keymaps = {
        ['<C-v>'] = 'actions.select_vsplit',
        ['<C-x>'] = 'actions.select_split',
        ['<C-t>'] = 'actions.select_tab',
        ['~'] = 'actions.tcd',
    },
    use_default_keymaps = true,
    view_options = {
        show_hidden = true
    },
})

require('core.keymap').set({
    {'<leader>o', function()
        require('oil').open_float(nil)
    end, desc = '[O]pen parent directory' },
})

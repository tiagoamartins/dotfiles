return {
    'NickvanDyke/opencode.nvim',
    depends = {
        'nvim-telescope/telescope.nvim',
    },
    cond = function()
        return vim.fn.executable('opencode') == 1
    end,
    config = function()
        vim.o.autoread = true
        vim.g.opencode_opts = {
            provider = {
                enabled = 'tmux',
                tmux = {
                    options = '-h -p 33',
                }
            }
        }
    end,
    keys = {
        {'<leader>Oq', function()
            require('opencode').ask('@this: ', {submit = true})
        end, desc = '[O]opencode [Q]uery'},
        {'<leader>Or', function()
            require('opencode').select()
        end, desc = '[O]pencode [R]un action…'},
        {'<leader>Ot', function()
            require('opencode').toggle()
        end, desc = '[O]pencode [T]oggle'},
        {'<leader>Ou', function()
            require('opencode').command('session.half.page.up')
        end, desc = 'opencode half page up'},
        {'<leader>Od', function()
            require('opencode').command('session.half.page.down')
        end, desc = 'opencode half page down'},
    },
}

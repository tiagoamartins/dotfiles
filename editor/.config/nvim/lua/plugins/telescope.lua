return {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    config = function(_, opts)
        tscope = require('telescope')
        actions = require('telescope.actions')
        themes = require('telescope.themes')

        tscope.setup({
            pickers = {
                help_tags = {
                    mappings = {
                        i = {['<enter>'] = actions.select_vertical}
                    }
                },
                man_pages = {
                    mappings = {
                        i = {['<enter>'] = actions.select_vertical}
                    }
                }
            },
            extensions = {
                ['ui-select'] = {
                    themes.get_dropdown()
                }
            }
        })
        tscope.load_extension('find_pickers')
        tscope.load_extension('fzf')
        tscope.load_extension('luasnip')
        tscope.load_extension('ui-select')
        tscope.load_extension('undo')
    end,
    version = '0.1.x',
    keys = {
        {'<leader>?', function()
            require('telescope.builtin').oldfiles()
        end, desc =  '[?] Find recently opened files'},
        {'<leader><leader>', function()
            require('telescope.builtin').buffers()
        end, desc =  '[\\] Find existing buffers'},
        {'<leader>/', function()
            builtin = require('telescope.builtin')
            themes = require('telescope.themes')

            builtin.current_buffer_fuzzy_find(themes.get_dropdown({
                winblend = 10,
                previewer = false,
            }))
        end, desc =  '[/] Fuzzily search in current buffer'},
        {'<leader>gf', function()
            require('telescope.builtin').git_files()
        end, desc = 'Search [G]it [F]iles'},
        {'<leader>sc', function()
            require('telescope.builtin').find_files({
                cwd = vim.fn.stdpath('config')
            })
        end, desc = '[S]earch [C]onfig'},
        {'<leader>sf', function()
            require('telescope.builtin').find_files({
                hidden = true,
                find_command = {
                    'rg',
                    '--files',
                    '--hidden',
                    '--glob=!**/.git/*',
                    '--glob=!**/build/*',
                    '--glob=!**/dist/*',
                }
            })
        end, desc = '[S]earch [F]iles'},
        {'<leader>sh', function()
            require('telescope.builtin').help_tags()
        end, desc = '[S]earch [H]elp'},
        {'<leader>sm', function()
            require('telescope.builtin').man_pages()
        end, desc = '[S]earch [M]anpages'},
        {'<leader>sw', function()
            require('telescope.builtin').grep_string()
        end, desc = '[S]earch current [W]ord'},
        {'<leader>sg', function()
            require('telescope.builtin').live_grep({
                additional_args = {
                    '--hidden',
                    '--no-ignore',
                    '--glob=!.git/*'
                }
            })
        end, desc = '[S]earch by [G]rep'},
        {'<leader>sd', function()
            require('telescope.builtin').diagnostics()
        end, desc = '[S]earch [D]iagnostics'},
        {'<leader>ss', function()
            require('telescope').extensions.luasnip.luasnip()
        end, desc = '[S]earch [S]nippets'},
        {'<leader>su', function()
            require('telescope').extensions.undo.undo()
        end, desc = '[S]earch [U]ndo tree'},
    },
}

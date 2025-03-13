return {
    'saghen/blink.cmp',
    version = '*',
    build = 'cargo build --release',
    opts = {
        appearance = {
            use_nvim_cmp_as_default = true,
            nerd_font_variant = 'mono',
        },
        keymap = {preset = 'default'},
        sources = {
            default = function(ctx)
                local success, node = pcall(vim.treesitter.get_node)
                local comments = {'comment', 'line_comment', 'block_comment'}

                if success and node and vim.tbl_contains(comments, node:type()) then
                    return {'buffer'}
                else
                    return {
                        'lsp',
                        'path',
                        'snippets',
                        'buffer'
                    }
                end
            end,
        },
        completion = {
            list = {
                selection = {
                    preselect = false,
                    auto_insert = false,
                }
            },
            accept = {
                auto_brackets = {enabled = false},
            },
            menu = {
                border = "rounded",
                winhighlight = "Normal:Normal,FloatBorder:BorderBG,CursorLine:PmenuSel,Search:None",

                draw = {
                    columns = {
                        {'label', 'label_description', gap = 1},
                        {'kind_icon', 'kind'}
                    },
                    treesitter = {'lsp'},
                }
            },
            -- show documentation when selecting a completion item
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 500
            },
            -- display a preview of the selected item on the current line
            ghost_text = {enabled = true},
        },
        signature = {enabled = true},
    },
    opts_extend = {'sources.default'}
}

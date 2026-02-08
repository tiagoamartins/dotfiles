local trigger_text = ';'
return {
    'saghen/blink.cmp',
    enabled = true,
    version = '1.*',
    opts = {
        enabled = function()
            local filetype = vim.bo[0].filetype
            if filetype == "TelescopePrompt"
                or filetype == "minifiles"
                or filetype == "snacks_picker_input" then
                return false
            end
            return true
        end,
        sources = {
            default = {'lsp', 'path', 'snippets', 'buffer'},
            providers = {
                lsp = {
                    name = 'lsp',
                    enabled = true,
                    module = 'blink.cmp.sources.lsp',
                    min_keyword_length = 0,
                    -- fallbacks = { "snippets", "buffer" },
                    score_offset = 90, -- the higher the number, the higher the priority
                },
                path = {
                    name = 'Path',
                    module = 'blink.cmp.sources.path',
                    score_offset = 25,
                    fallbacks = {'snippets', 'buffer'},
                    -- min_keyword_length = 2,
                    opts = {
                        trailing_slash = false,
                        label_trailing_slash = true,
                        get_cwd = function(context)
                            return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
                        end,
                        show_hidden_files_by_default = true,
                    },
                },
                buffer = {
                    name = 'Buffer',
                    enabled = true,
                    max_items = 3,
                    module = 'blink.cmp.sources.buffer',
                    min_keyword_length = 2,
                    score_offset = 15, -- the higher the number, the higher the priority
                },
                snippets = {
                    name = 'snippets',
                    enabled = true,
                    max_items = 15,
                    min_keyword_length = 2,
                    module = 'blink.cmp.sources.snippets',
                    score_offset = 85, -- the higher the number, the higher the priority
                    should_show_items = function()
                        local col = vim.api.nvim_win_get_cursor(0)[2]
                        local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
                        return before_cursor:match(trigger_text .. "%w*$") ~= nil
                    end,
                    transform_items = function(_, items)
                        local line = vim.api.nvim_get_current_line()
                        local col = vim.api.nvim_win_get_cursor(0)[2]
                        local before_cursor = line:sub(1, col)
                        local start_pos, end_pos = before_cursor:find(trigger_text .. "[^" .. trigger_text .. "]*$")
                        if start_pos then
                            for _, item in ipairs(items) do
                                if not item.trigger_text_modified then
                                    ---@diagnostic disable-next-line: inject-field
                                    item.trigger_text_modified = true
                                    item.textEdit = {
                                        newText = item.insertText or item.label,
                                        range = {
                                            start = { line = vim.fn.line(".") - 1, character = start_pos - 1 },
                                            ["end"] = { line = vim.fn.line(".") - 1, character = end_pos },
                                        },
                                    }
                                end
                            end
                        end
                        return items
                    end,
                },
            },
        },
        cmdline = {
            enabled = false,
        },
        completion = {
            menu = {
                border = 'none',
            },
            documentation = {
                auto_show = true,
                window = {
                    border = 'none',
                },
            },
        },
        snippets = {
            preset = 'luasnip', -- Choose LuaSnip as the snippet engine
        },
        keymap = {
            preset = 'default',
        }
    }
}

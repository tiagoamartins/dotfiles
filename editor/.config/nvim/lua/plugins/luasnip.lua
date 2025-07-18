return {
    'L3MON4D3/LuaSnip',
    lazy = true,
    config = function(_, opts)
        local ls = require('luasnip')

        vim.snippet.expand = ls.lsp_expand

        vim.snippet.active = function(filter)
            filter = filter or {}
            filter.direction = filter.direction or 1

            if filter.direction == 1 then
                return ls.expand_or_jump()
            else
                return ls.jumpable(filter.firection)
            end
        end

        vim.snippet.jump = function(direction)
            if direction == 1 then
                if ls.expandable() then
                    return ls.expand_or_jump()
                else
                    return ls.jumpable(1) and ls.jump(1)
                end
            else
                return ls.jumpable(-1) and ls.jump(-1)
            end
        end

        vim.snippet.stop = ls.unlink_current

        ls.config.set_config(opts)

        for _, ft_path in ipairs(vim.api.nvim_get_runtime_file('lua/snippets/*.lua', true)) do
            loadfile(ft_path)()
        end

        vim.keymap.set({'i', 's'}, '<leader>f', function()
            return vim.snippet.active({direction = 1}) and vim.snippet.jump(1)
        end, {silent = true})
        vim.keymap.set({'i', 's'}, '<leader>b', function()
            return vim.snippet.active({direction = -1}) and vim.snippet.jump(-1)
        end, {silent = true})
    end,
    opts = {
        history = true,
        updateevents = 'TextChanged,TextChangedI',
        override_builtin = true,
    }
}

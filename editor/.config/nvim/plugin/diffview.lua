vim.pack.add({'https://github.com/dlyongemallo/diffview-plus.nvim'})

require('diffview').setup({
    enhanced_diff_hl = true,
    use_icons = false,
    hooks = {
        diff_buf_read = function(bufnr)
            vim.opt_local.wrap = true
        end,
        view_opened = function(view)
            print(('A new %s was opened on tab page %d!'):format(
                view.class:name(),
                vim.api.nvim_tabpage_get_number(view.tabpage)
            ))
        end,
        diff_buf_win_enter = function(bufnr, winid, ctx)
            -- Re-trigger treesitter-context's on_attach evaluation.
            -- The group name is an internal detail of nvim-treesitter-context
            -- and may differ across versions; verify it matches your install
            -- or omit it to fire all BufReadPost handlers.
            -- `modeline = false` prevents `nvim_exec_autocmds`'s default
            -- post-autocmd modeline pass from running `:set` commands (e.g.
            -- `fileencoding`) against the diffview buffer, which is
            -- non-modifiable and would raise E21.
            pcall(vim.api.nvim_exec_autocmds, 'BufReadPost', {
                buffer = bufnr,
                group = 'treesitter_context_update',
                modeline = false,
            })
        end,
        view_closed = function()
            local ok, tsc = pcall(require, 'treesitter-context')
            if ok and tsc.enabled() then
                tsc.enable()
            end
        end,
    },
    view = {
        merge_tool = {
            layout = 'diff4_mixed',
            disable_diagnostics = true,
            winbar_info = true,
        },
    },
})

local mappings = {
    {'<leader>dc', '<cmd>DiffviewClose<cr>', desc = '[D]iffview [C]lose'},
    {'<leader>do', '<cmd>DiffviewOpen<cr>', desc = '[D]iffview [O]pen'},
    {'<leader>dO', ':DiffviewOpen ', desc = '[D]iffview [O]pen Prompt'},
    {'<leader>dr', '<cmd>DiffviewRefresh<cr>', desc = '[D]iffview [R]efresh'},
    {'<leader>dh', '<cmd>DiffviewFileHistory %<cr>', desc = '[D]iffview file [H]istory (current file)'},
    {'<leader>dh', "<Esc><cmd>'<,'>DiffviewFileHistory --follow<CR>", desc = '[D]iffview range [H]istory', mode = 'v'},
    {'<leader>dH', '<cmd>DiffviewFileHistory<cr>', desc = '[D]iffview file [H]istory (repo)'},
    {'<leader>dl', '<cmd>.DiffviewFileHistory --follow<CR>', desc = '[D]iffview [L]ine history'},
    -- diff against main/master branch (useful before merging)
    {'<leader>dm', function()
        local result = vim.fn.systemlist({'git', 'rev-parse', '--verify', 'main'})
        local ok = vim.v.shell_error == 0 and result[1] ~= nil and result[1] ~= ''

        local branch = ok and 'main' or 'master'
        vim.cmd('DiffviewOpen ' .. branch)
    end, desc = '[D]iff view against [M]ain/master'},
    -- diff against a branch selected via Telescope
    {'<leader>db', function()
        require('telescope.builtin').git_branches({
            attach_mappings = function(_, map)
                map('i', '<CR>', function(prompt_bufnr)
                    local selection = require('telescope.actions.state').get_selected_entry()
                    require('telescope.actions').close(prompt_bufnr)
                    vim.cmd('DiffviewOpen ' .. selection.value)
                end)
                return true
            end,
        })
    end, desc = '[D]iffview [B]ranch'},
    -- file history for a commit selected via Telescope
    {'<leader>dC', function()
        require('telescope.builtin').git_commits({
            attach_mappings = function(_, map)
                map('i', '<CR>', function(prompt_bufnr)
                    local selection = require('telescope.actions.state').get_selected_entry()
                    require('telescope.actions').close(prompt_bufnr)
                    vim.cmd('DiffviewOpen ' .. selection.value .. '^!')
                end)
                return true
            end,
        })
    end, desc = '[D]iffview [C]ommit'},
}

require('core.keymap').set(mappings)

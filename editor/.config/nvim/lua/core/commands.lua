local commands = {
    pack_show = {
        name = 'PackShow',
        func = function ()
            vim.pack.update(nil, {offline = true})
        end
    },
    pack_update = {
        name = 'PackUpdate',
        func = function ()
            vim.pack.update(nil)
        end,
    },
    pack_clean = {
        name = 'PackClean',
        func = function()
            local stale = vim.iter(vim.pack.get())
                :filter(function(p) return not p.active end)
                :map(function(p) return p.spec.name end)
                :totable()

            if #stale == 0 then
                vim.notify('PackClean: nothing to remove')
                return
            end

            local choice = vim.fn.confirm(
                'Delete inactive plugins?\n  ' .. table.concat(stale, '\n  '),
                '&Yes\n&No', 2)
            if choice == 1 then
                vim.pack.del(stale)
            end
        end,
    },
    tags = {
        name = 'MakeTags',
        func = function()
            vim.fn.jobstart('ctags -R .')
        end,
    },
}

for _, c in pairs(commands) do
    vim.api.nvim_create_user_command(c.name, c.func, c.opts or {})
end

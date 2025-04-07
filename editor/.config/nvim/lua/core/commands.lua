local commands = {
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

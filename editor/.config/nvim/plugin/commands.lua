vim.api.nvim_create_user_command('MakeTags', function ()
    vim.fn.jobstart('ctags -R .')
end, {})

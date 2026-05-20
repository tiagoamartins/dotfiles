if vim.fn.executable('aider') == 1 then
    vim.pack.add({'https://github.com/joshuavial/aider.nvim'})

    require('aider').setup({
        auto_manage_context = true,
        default_bindings = false,
        debug = false,
    })
end

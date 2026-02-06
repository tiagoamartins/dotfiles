return {
    'joshuavial/aider.nvim',
    cond = function()
        return vim.fn.executable('aider') == 1
    end,
    opts = {
        auto_manage_context = true,
        default_bindings = true,
        debug = false,
    },
}

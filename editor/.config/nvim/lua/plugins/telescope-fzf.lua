return {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    lazy = true,
    cond = function()
        return vim.fn.executable('make') == 1
    end,
}

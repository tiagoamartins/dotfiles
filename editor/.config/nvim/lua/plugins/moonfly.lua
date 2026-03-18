return {
    'bluz71/vim-moonfly-colors',
    name = 'moonfly',
    lazy = false,
    priority = 1000,
    config = function(_, _)
        vim.g.moonflyTransparent = true
    end,
}

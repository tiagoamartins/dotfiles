vim.pack.add({'https://github.com/nvim-treesitter/nvim-treesitter-context'})

require('treesitter-context').setup({
    on_attach = function(buf)
        return not vim.b[buf].ts_context_disable
    end,
})

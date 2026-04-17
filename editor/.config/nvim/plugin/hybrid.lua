vim.pack.add({'https://github.com/honamduong/hybrid.nvim'})

require('hybrid').setup({
    terminal_colors = true,
    undercurl = true,
    underline = true,
    bold = true,
    italic = {
        strings = false,
        emphasis = true,
        comments = true,
        folds = true,
    },
    strikethrough = true,
    inverse = true,
    transparent = false,
    overrides = function(highlights, _)
        highlights.StatusLineNC = {
            bg = '#303030',
            fg = '#6C6C6C'
        }
        highlights.TelescopeTitle = {
            bold = true,
        }
    end,
})

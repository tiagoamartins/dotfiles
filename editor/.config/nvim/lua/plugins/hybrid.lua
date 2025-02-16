return {
    'HoNamDuong/hybrid.nvim',
    lazy = false,
    priority = 1000,
    config = function(_, opts)
        require('hybrid').setup(opts)
        vim.cmd.colorscheme('hybrid')
    end,
    opts = {
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
        overrides = function(highlights, colors)
            highlights.StatusLineNC = {
                bg = '#303030',
                fg = '#6C6C6C'
            }
            highlights.TelescopeTitle = {
                bold = true,
            }
        end,
    }
}

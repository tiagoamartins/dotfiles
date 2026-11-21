vim.g.moonflyTransparent = true

vim.pack.add({'https://github.com/bluz71/vim-moonfly-colors'})

-- re-apply the bold attribute on ColorScheme load so Markdown strong emphasis
-- renders in bold while preserving moonfly's palette colors.
local moonfly_hl = vim.api.nvim_create_augroup('MoonflyCustomHighlights', {clear = true})
vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = 'moonfly',
    group = moonfly_hl,
    callback = function()
        local palette = require('moonfly').palette
        vim.api.nvim_set_hl(0, '@markup.strong', {fg = palette.orchid, bold = true})
        vim.api.nvim_set_hl(0, 'markdownBold', {fg = palette.yellow, bold = true})
    end,
})

vim.cmd.colorscheme('moonfly')

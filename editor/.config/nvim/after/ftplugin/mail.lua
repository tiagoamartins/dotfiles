-- if you use long lines, mutt will automatically switch to quoted-printable
-- encoding. This will generally look better in most places that matter (eg.
-- gmail), where hard-wrapped email looks terrible and format=flowed is not
-- supported.

local set = vim.opt_local

set.textwidth = 0
set.foldmethod = 'manual'
set.wrap = true
set.spell = true


vim.api.nvim_create_augroup('mutt_composing', {clear = true})
vim.api.nvim_create_autocmd('BufEnter', {
    group = 'mutt_composing',
    pattern = '/tmp/{mutt,neomutt}-*',
    callback = function()
        vim.cmd('1,/^$/-1fold')
        vim.cmd.normal('}')

        local row = vim.api.nvim_win_get_cursor(0)[1]
        local line = vim.api.nvim_buf_get_lines(0, row, row + 2, false)
        local last = vim.api.nvim_buf_line_count(0)

        if row == last or (line[2] ~= nil and string.find(line[2], '^%-%-%s+$')) then
            vim.api.nvim_buf_set_lines(0, row, row, true, {''})
        elseif string.find(line[1], '%-+%s+Forwarded message')
                or (line[2] ~= nil and string.find(line[2], '>')) then
            vim.api.nvim_buf_set_lines(0, row, row, true, {'', ''})
        end

        vim.cmd('+1')
    end
})

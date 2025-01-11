local M = {}

function M.mark_swap()
    vim.g.marked_win_num = vim.api.nvim_get_current_win()
end

function M.do_swap()
    local cur_win = vim.api.nvim_get_current_win()
    local cur_buf = vim.api.nvim_get_current_buf()
    local mrk_buf = vim.api.nvim_win_get_buf(vim.g.marked_win_num)

    vim.api.nvim_win_set_buf(vim.g.marked_win_num, cur_buf)
    vim.api.nvim_win_set_buf(cur_win, mrk_buf)
end

return M

local M = {}

function M.preserve(command)
    -- preparation: save last search, and cursor position
    local s = vim.fn.getreg('/', 1)
    local c = vim.fn.getcurpos()

    -- do the business
    vim.cmd(command)

    -- clean up: restore previous search history, and cursor position
    vim.fn.setreg('/', s)
    vim.fn.setpos('.', c)
end

return M

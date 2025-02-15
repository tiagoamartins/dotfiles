local M = {}

-- sends default register to terminal TTY using OSC 52 escape sequence
function M.osc52(text)
    local buffer = vim.fn.system('yank', text)

    if vim.v.shell_error == 1 then
    vim.api.nvim_err_writeln(buffer)
    end
end

return M

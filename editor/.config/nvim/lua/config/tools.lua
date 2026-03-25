local M = {}

function M.get_default_debuggers()
    return {
        'arm-none-eabi-gdb',
        'debugpy',
        'gdb',
        'vgdb',
    }
end

function M.get_debuggers()
    return vim.g.debuggers or M.get_default_debuggers()
end

function M.has_debuggers()
    for _, v in ipairs(require('config.tools').get_debuggers()) do
        if vim.fn.executable(v) == 1 then
            return true
        end
    end

    return false
end

function M.get_default_linters()
    return {
        'ansible-lint',
        'yamllint',
    }
end

function M.get_linters()
    return vim.g.linters or M.get_default_linters()
end

return M

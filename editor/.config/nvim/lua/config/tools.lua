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

function M.get_custom_tools()
    return {
        'arm-none-eabi-gdb',
        'gdb',
        'veridian',
        'vgdb',
    }
end

function M.append_tools(set, tools)
    local custom = M.get_custom_tools()

    for _, v in ipairs(tools) do
        local found = false

        for _, c in ipairs(custom) do
            if string.match(v, c) then
                found = true
            end
        end

        if not found then
            table.insert(set, v)
        end
    end

    return set
end

function M.get_tools()
    local tools = {}

    tools = M.append_tools(tools, M.get_debuggers())
    tools = M.append_tools(tools, M.get_linters())
    tools = M.append_tools(tools, require('config.lsp').get_servers())

    return tools
end

return M

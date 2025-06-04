local M = {}

function M.get_default_debuggers()
    return {
        'debugpy',
    }
end

function M.get_debuggers()
    return vim.g.debuggers or M.get_default_debuggers()
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
        'veridian',
    }
end

function M.append_tools(set, tools)
    local custom = M.get_custom_tools()

    for k, v in pairs(tools) do
        if custom[k] == nil then
            set[k] = v
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

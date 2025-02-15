local M = {}

function M.has(plugin)
    return require('lazy.core.config').plugins[plugin] ~= nil
end

function M.get_python_path()
    local venv = os.getenv("VIRTUAL_ENV")
    if venv then
        return venv .. '/bin/python'
    else
        return '/usr/bin/python'
    end
end

return M

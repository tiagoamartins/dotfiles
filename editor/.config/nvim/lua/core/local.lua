local function notify_error(path, err)
    vim.notify('Error loading ' .. path .. ': ' .. err, vim.log.levels.ERROR)
end

local function load_file(path)
    if vim.uv.fs_stat(path) then
        local ok, err = pcall(dofile, path)
        if not ok then
            notify_error(path, err)
        end
    end
end

local function load_project_file(path)
    if not vim.uv.fs_stat(path) then
        return
    end

    local src = vim.secure.read(path)
    if type(src) ~= 'string' then
        return -- not trusted (or denied)
    end

    local chunk, err = load(src, '@' .. path)
    if not chunk then
        notify_error(path, err)
        return
    end

    local ok, run_err = pcall(chunk)
    if not ok then
        notify_error(path, run_err)
    end
end

load_file(vim.fn.stdpath('config') .. '/init.lua.local')
load_project_file(vim.fn.getcwd() .. '/.nvim-config.lua')

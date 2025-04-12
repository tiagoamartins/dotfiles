local function load_file(path)
    if (vim.uv or vim.loop).fs_stat(path) then
        -- read the file and run it with pcall to catch any errors
        local ok, err = pcall(dofile, path)
        if not ok then
            vim.notify("Error loading setting: " .. err, vim.log.levels.ERROR)
        end
    end
end

load_file(vim.fn.stdpath('config') .. '/init.lua.local')
load_file(vim.fn.getcwd() .. '/.nvim-config.lua')

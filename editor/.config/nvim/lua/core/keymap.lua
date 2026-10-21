local M = {}

function M.set(mappings, mode)
    for _, map in ipairs(mappings) do
        local opts = {}
        for k, v in pairs(map) do
            if type(k) ~= 'number' and k ~= 'mode' then
                opts[k] = v
            end
        end
        vim.keymap.set(map.mode or mode or 'n', map[1], map[2], opts)
    end
end

return M

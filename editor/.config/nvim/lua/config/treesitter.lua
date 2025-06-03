local M = {}

function M.get_default_parsers()
    return {
        'asm',
        'bash',
        'c',
        'comment',
        'cpp',
        'html',
        'jinja',
        'json',
        'lua',
        'markdown',
        'markdown_inline',
        'objdump',
        'python',
        'rst',
        'verilog',
        'vim',
        'vimdoc',
        'yaml',
    }
end

function M.get_parsers()
    return vim.g.treesitter_parsers or M.get_default_parsers()
end

function M.get_filetypes()
    local filetypes = {}
    local filetype_set = {}

    for _, parser in ipairs(M.get_parsers()) do
        local fts = vim.treesitter.language.get_filetypes(parser)

        for _, ft in ipairs(fts) do
            filetype_set[ft] = true
        end
    end

    for ft in pairs(filetype_set) do
        table.insert(filetypes, ft)
    end

    return filetypes
end

return M

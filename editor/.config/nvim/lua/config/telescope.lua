local conf = require('telescope.config').values
local finders = require('telescope.finders')
local make_entry = require('telescope.make_entry')
local pickers = require('telescope.pickers')

local M = {}

function M.live_multigrep(opts)
    opts = opts or {}
    opts.cwd = opts.cwd and vim.fn.expand(opts.cwd) or vim.uv.cwd()
    opts.shortcuts = opts.shortcuts or {
        ['c'] = '*.c',
        ['g'] = '*.go',
        ['l'] = '*.lua',
        ['n'] = '*.{vim,lua}',
        ['p'] = '*.py',
        ['r'] = '*.rs',
        ['s'] = '*.{sv,v}',
        ['v'] = '*.vim',
    }
    opts.pattern = opts.pattern or '%s'

    local custom_grep = finders.new_async_job({
        command_generator = function(prompt)
            if not prompt or prompt == '' then
                return nil
            end

            local pieces = vim.split(prompt, '  ')
            local args = {'rg'}
            if pieces[1] then
                table.insert(args, '-e')
                table.insert(args, pieces[1])
            end

            if pieces[2] then
                table.insert(args, '-g')

                local pattern
                if opts.shortcuts[pieces[2]] then
                    pattern = opts.shortcuts[pieces[2]]
                else
                    pattern = pieces[2]
                end

                table.insert(args, string.format(opts.pattern, pattern))
            end

            return vim.iter({
                args, {
                    '--color=never',
                    '--no-heading',
                    '--with-filename',
                    '--line-number',
                    '--column',
                    '--smart-case'
                },
                opts.additional_args or {}
            }):flatten():totable()
        end,
        entry_maker = make_entry.gen_from_vimgrep(opts),
        cwd = opts.cwd,
    })

    pickers.new(opts, {
        debounce = 100,
        prompt_title = 'Live Grep (with shortcuts)',
        finder = custom_grep,
        previewer = conf.grep_previewer(opts),
        sorter = require('telescope.sorters').empty(),
    }):find()
end

return M

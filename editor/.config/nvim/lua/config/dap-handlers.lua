local M = {}

function M.get_executable()
    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local conf = require('telescope.config').values
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')

    return coroutine.create(function(coro)
        local opts = {}
        pickers.new(opts, {
            prompt_title = 'Path to executable',
            finder = finders.new_oneshot_job({
                'fd', '--no-ignore', '--type', 'x'
            }, {}),
            sorter = conf.generic_sorter(opts),
            attach_mappings = function(buffer_number)
                actions.select_default:replace(function()
                    actions.close(buffer_number)
                    coroutine.resume(coro, action_state.get_selected_entry()[1])
                end)
                return true
            end,
        }):find()
    end)
end

function M.get_arguments()
    local args = vim.fn.input('Arguments: ')
    local chunks = {}
    for substring in args:gmatch('%S+') do
        table.insert(chunks, substring)
    end
    return chunks
end

return M

local M = {}

function get_executable()
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

local function get_arguments()
	local args = vim.fn.input('Arguments: ')
	local chunks = {}
	for substring in args:gmatch('%S+') do
		table.insert(chunks, substring)
	end
	return chunks
end

local function inject_exe_args(config)
	for _, cfg in pairs(config.configurations) do
		if cfg.type == 'cppdbg' and cfg.program ~= nil then
			cfg.program = get_executable
			cfg.args = get_arguments
		end
	end
end

local function default_handler(config)
	inject_exe_args(config)
	require('mason-nvim-dap').default_setup(config)
end

local function cppdbg_handler(config)
	inject_exe_args(config)
	table.insert(config.configurations, {
		name = 'Attach to gdbserver (valgrind)',
		type = 'cppdbg',
		request = 'launch',
		MIMode = 'gdb',
		miDebuggerServerAddress = '| ' .. vim.fn.exepath('vgdb'),
		miDebuggerPath = vim.fn.exepath('gdb'),
		cwd = '${workspaceFolder}',
		program = get_executable,
		args = get_arguments
	})
	require('mason-nvim-dap').default_setup(config)
end

local function python_handler(config)
	local prev_adapter = config.adapters
	config.adapters =  function(callback, config)
		if config.request == 'attach' then
			local port = (config.connect or config).port
			local host = (config.connect or config).host or '127.0.0.1'
			callback({
				type = 'server',
				port = assert(port, '`connect.port` is required for a python `attach` configuration'),
				host = host,
				options = {
					source_filetype = 'python'
				},
			})
		else
			callback(prev_adapter)
		end
	end
	require('mason-nvim-dap').default_setup(config)
end

function M.setup_handlers()
	return {
		default_handler,
		cppdbg = cppdbg_handler,
		python = python_handler
	}
end

return M

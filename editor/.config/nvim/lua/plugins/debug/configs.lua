local M = {}

local get_python_path = require('config.util').get_python_path

local function get_executable()
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

function M.all()
	return {
		cpp = M.cpp(),
		c = M.c(),
		rust = M.rust(),
		python = M.python(),
	}
end

function M.cpp()
	return {
		{
			name = "Launch file (GDB)",
			type = "cppdbg",
			request = "launch",
			program = get_executable,
			cwd = '${workspaceFolder}',
			stopOnEntry = true,
		}, {
			type = 'lldb',
			request = 'launch',
			name = 'Launch file (LLDB)',
			program = get_executable,
			cwd = '${workspaceFolder}',
			stopOnEntry = true,
			runInTerminal = false,
		}, {
			name = "Launch with custom arguments (GDB)",
			type = "cppdbg",
			request = "launch",
			program = get_executable,
			cwd = '${workspaceFolder}',
			stopOnEntry = true,
			args = get_arguments,
			runInTerminal = false,
		}, {
			type = 'lldb',
			request = 'launch',
			name = 'Launch with custom arguments (LLDB)',
			program = get_executable,
			cwd = '${workspaceFolder}',
			stopOnEntry = true,
			args = get_arguments,
			runInTerminal = false,
		}, {
			name = 'Attach to gdbserver (port 3333)',
			type = 'cppdbg',
			request = 'launch',
			MIMode = 'gdb',
			miDebuggerServerAddress = 'localhost:3333',
			miDebuggerPath = '/usr/bin/gdb',
			cwd = '${workspaceFolder}',
			program = get_executable,
		}, {
			name = 'Attach to gdbserver (valgrind)',
			type = 'cppdbg',
			request = 'launch',
			MIMode = 'gdb',
			miDebuggerServerAddress = '| /usr/bin/vgdb',
			miDebuggerPath = '/usr/bin/gdb',
			cwd = '${workspaceFolder}',
			program = get_executable,
		}
	}
end

function M.c() return M.cpp() end

function M.rust() return M.cpp() end

function M.python()
	return {
		{
			type = 'python';
			request = 'launch';
			name = 'Launch file';
			program = '${file}';
			console = 'integratedTerminal',
			pythonPath = get_python_path;
		}, {
			type = 'python';
			request = 'launch';
			name = 'Launch file with arguments';
			program = '${file}';
			args = get_arguments,
			console = 'integratedTerminal',
			pythonPath = get_python_path;
		}
	}
end

return M

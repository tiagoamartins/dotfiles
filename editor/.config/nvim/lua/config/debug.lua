local ok, dap = pcall(require, 'dap')
if not ok then
	return
end

local get_python_path = function()
	local venv = os.getenv("VIRTUAL_ENV")
	if venv then
		return venv .. '/bin/python'
	else
		return '/usr/bin/python'
	end
end

local get_executable = function()
	return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
end

local get_arguments = function()
	local args = vim.fn.input('Arguments: ')
	local chunks = {}
	for substring in args:gmatch('%S+') do
		table.insert(chunks, substring)
	end
	return chunks
end

local enrich_config = function(config, on_config)
	if not config.pythonPath and not config.python then
		config.pythonPath = get_python_path()
	end
	on_config(config)
end

-- vim.fn.sign_define('DapBreakpoint', {text='B', texthl='', linehl='DapLineRun', numhl=''})
-- vim.cmd([[exec 'highlight DapLineRun ctermbg=12 guibg=#81a2be']])
dap.defaults.fallback.terminal_win_cmd = [[ belowright new ]]

vim.cmd (
	[[autocmd TermClose *                     |]]..
	[[if !v:event.status                      |]]..
	[[    exe 'bdelete! ' .. expand('<abuf>') |]]..
	[[endif                                   ]]
)
vim.cmd([[au FileType dap-repl lua require('dap.ext.autocompl').attach()]])

dap.adapters.lldb = {
	type = 'executable',
	command = 'lldb-vscode',
	name = "lldb"
}
dap.adapters.python = {
	type = 'executable',
	command = get_python_path(),
	args = {'-m', 'debugpy.adapter'},
	enrich_config = enrich_config
}
dap.adapters.cppdbg = {
	type = 'executable',
	command = os.getenv('HOME') .. '/.local/share/nvim/cpptools/extension/debugAdapters/bin/OpenDebugAD7',
	id = 'cppdbg'
}

dap.configurations.cpp = {
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
		name = "Launch with arguments (GDB)",
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
		name = 'Launch with arguments (LLDB)',
		program = get_executable,
		cwd = '${workspaceFolder}',
		stopOnEntry = true,
		args = get_arguments,
		runInTerminal = false,
	}, {
		name = 'Attach to gdbserver (port 1234)',
		type = 'cppdbg',
		request = 'launch',
		MIMode = 'gdb',
		miDebuggerServerAddress = 'localhost:1234',
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
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp
dap.configurations.python = {
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

local repl = require('dap.repl')
repl.commands = vim.tbl_extend('force', repl.commands, {
	exit = {'exit', '.exit', '.bye'},
	custom_commands = {
		['.echo'] = function(text)
			dap.repl.append(text)
		end,
		['.restart'] = dap.restart,
	}
})

local ok, dap_ui = pcall(require, 'dapui')
if ok then
	dap_ui.setup()
end

dap.listeners.after.event_initialized["dapui_config"] = function()
	dap_ui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dap_ui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dap_ui.close()
end

local ok, dap_virtualtxt = pcall(require, 'nvim-dap-virtual-text')
if ok then
	dap_virtualtxt.setup({
		enabled = true,
		enabled_commands = true,
		highlight_changed_variables = true,
		highlight_new_as_changed = false,
		show_stop_reason = true,
		commented = false,
	})
end

local function map(...) vim.api.nvim_set_keymap(...) end
s_noremap = {noremap = true, silent = true}

-- dap
map('n', '<leader>ds', [[<cmd>lua require('dap').terminate()<cr>]], s_noremap)
map('n', '<leader>b', [[<cmd>lua require('dap').toggle_breakpoint()<cr>]], s_noremap)
map('n', '<leader>B', [[<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>]], s_noremap)
map('n', '<leader>lp', [[<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>]], s_noremap)
map('n', '<leader>dr', [[<cmd>lua require('dap').repl.toggle()<cr>]], s_noremap)
map('n', '<leader>dl', [[<cmd>lua require('dap').run_last()<cr>]], s_noremap)

local api = vim.api
local keymap_restore = {}
dap.listeners.after['event_initialized']['me'] = function()
	for _, buf in pairs(api.nvim_list_bufs()) do
		local keymaps = api.nvim_buf_get_keymap(buf, 'n')
		for _, keymap in pairs(keymaps) do
			if keymap.lhs == "K" then
				table.insert(keymap_restore, keymap)
				api.nvim_buf_del_keymap(buf, 'n', 'K')
			end
		end
	end
	api.nvim_set_keymap('n', 'K', '<cmd>lua require("dapui").eval()<cr>', { silent = true })
end

dap.listeners.after['event_terminated']['me'] = function()
	for _, keymap in pairs(keymap_restore) do
		api.nvim_buf_set_keymap(
			keymap.buffer,
			keymap.mode,
			keymap.lhs,
			keymap.rhs,
		{ silent = keymap.silent == 1 }
		)
	end
	keymap_restore = {}
end

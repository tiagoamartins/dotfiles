local M = {}

local get_python_path = require('config.util').get_python_path

local function enrich_config(config, on_config)
	if not config.pythonPath and not config.python then
		config.pythonPath = get_python_path()
	end
	on_config(config)
end

function M.all()
	return {
		lldb = {
			type = 'executable',
			command = 'lldb-vscode',
			name = "lldb"
		},
		python = {
			type = 'executable',
			command = get_python_path(),
			args = {'-m', 'debugpy.adapter'},
			enrich_config = enrich_config
		},
		cppdbg = {
			type = 'executable',
			command = os.getenv('HOME') .. '/.local/share/nvim/cpptools/extension/debugAdapters/bin/OpenDebugAD7',
			id = 'cppdbg'
		}
	}
end

return M

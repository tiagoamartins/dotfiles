local M = {}

local get_python_path = require('config.util').get_python_path

function M.all()
	return {
		lldb = {
			type = 'executable',
			command = 'lldb-vscode',
			name = 'lldb'
		},
		python = function(cb, config)
			if config.request == 'attach' then
				local port = (config.connect or config).port
				local host = (config.connect or config).host or '127.0.0.1'
				cb({
					type = 'server',
					port = assert(port, '`connect.port` is required for a python `attach` configuration'),
					host = host,
					options = {
						source_filetype = 'python'
					},
				})
			else
				cb({
					type = 'executable',
					command = get_python_path(),
					args = {'-m', 'debugpy.adapter'},
					options = {
						source_filetype = 'python'
					},
				})
			end
		end,
		cppdbg = {
			type = 'executable',
			command = os.getenv('HOME') .. '/.local/share/nvim/cpptools/extension/debugAdapters/bin/OpenDebugAD7',
			id = 'cppdbg'
		}
	}
end

return M

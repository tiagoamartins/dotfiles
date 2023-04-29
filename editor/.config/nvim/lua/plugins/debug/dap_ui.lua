local M = {}

function M.setup()
	local dap_ui = require('dapui')
	dap_ui.setup()

	local dap = require('dap')
	dap.listeners.after.event_initialized['dapui_config'] = function() dap_ui.open() end
	dap.listeners.before.event_terminated['dapui_config'] = function() dap_ui.close() end
	dap.listeners.before.event_exited['dapui_config'] = function() dap_ui.close() end

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
				{silent = keymap.silent == 1}
			)
		end
		keymap_restore = {}
	end
end

return M

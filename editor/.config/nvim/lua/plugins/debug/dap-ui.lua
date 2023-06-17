local function config()
	local dap_ui = require('dapui')
	dap_ui.setup()

	local dap = require('dap')
	dap.listeners.after.event_initialized['dapui_config'] = function() dap_ui.open() end
	dap.listeners.before.event_terminated['dapui_config'] = function() dap_ui.close() end
	dap.listeners.before.event_exited['dapui_config'] = function() dap_ui.close() end

	local api = vim.api
	local keymap_restore = {}
	dap.listeners.after.event_initialized['me'] = function()
		for _, buf in pairs(api.nvim_list_bufs()) do
			local keymaps = api.nvim_buf_get_keymap(buf, 'n')
			for _, keymap in pairs(keymaps) do
				if keymap.lhs == 'K' and keymap.rhs ~= nil then
					table.insert(keymap_restore, keymap)
					vim.keymap.del('n', 'K', {buffer = buf})
				end
			end
		end
		vim.keymap.set('n', 'K', function() require('dap.ui.widgets').hover() end, {silent = true})
	end

	dap.listeners.after.event_terminated['me'] = function()
		for _, keymap in pairs(keymap_restore) do
			vim.keymap.set(keymap.mode, keymap.lhs, keymap.rhs, {
				buffer = keymap.buffer, silent = (keymap.silent == 1)
			})
		end
		keymap_restore = {}
	end
end

return {
	'rcarriga/nvim-dap-ui',
	keys = {
		{'<f3>', function() require('dapui').toggle() end, desc = 'DAP: Activate UI'},
	},
	config = config
}

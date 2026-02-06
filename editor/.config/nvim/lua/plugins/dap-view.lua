return {
    'igorlfs/nvim-dap-view',
    cond = require('config.tools').has_debuggers(),
    opts = {},
    keys = {
        {'<f3>', '<cmd>DapViewToggle<cr>', desc = 'DAP: Toggle view'},
        {'<leader>w', '<cmd>DapViewWatch<cr>', desc = 'DAP: View [W]atch'},
        {'<leader>K', function()
            require('dap.ui.widgets').hover(nil, {border = 'rounded'})
        end, desc = 'DAP: Hover [K]'},
        {'<leader>S', function()
            local widgets = require('dap.ui.widgets')
            widgets.centered_float(widgets.scopes, {border = 'rounded'})
        end, desc = 'DAP: [S]copes'},
    },
}

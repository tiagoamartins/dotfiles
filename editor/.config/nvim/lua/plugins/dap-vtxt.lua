return {
    'theHamsta/nvim-dap-virtual-text',
    cond = require('config.tools').has_debuggers(),
    lazy = true,
    opts = {
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
    }
}

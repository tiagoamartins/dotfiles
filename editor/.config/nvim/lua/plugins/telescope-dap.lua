return {
    'nvim-telescope/telescope-dap.nvim',
    cond = require('config.tools').has_debuggers(),
    lazy = true
}

return {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = {
        ensure_installed = require('config.tools').get_tools()
    },
}

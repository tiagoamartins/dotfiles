return {
    'L3MON4D3/LuaSnip',
    build = 'make install_jsregexp',
    config = function(_, _)
        require('config.snippets')
    end,
}

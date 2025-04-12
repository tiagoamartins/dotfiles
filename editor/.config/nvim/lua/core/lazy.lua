local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        '--branch=stable',
        lazyrepo,
        lazypath
    })

    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            {'Failed to clone lazy.nvim:\n', 'ErrorMsg'},
            {out, 'WarningMsg'},
            {'\nPress any key to exit...'},
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end

-- add lazy to the `runtimepath`, so it can be used with `require`
vim.opt.rtp:prepend(lazypath)

-- load plugin information from the `plugins` directory
local specs = {
    {import = 'plugins'},
}

-- load extra plugins base on vim.g.enable_extra_plugins and merge to specs
local extra_plugins = vim.g.enable_extra_plugins
if extra_plugins then
    for _, plugin in ipairs(vim.g.enable_extra_plugins) do
        table.insert(specs, {
            import = 'plugins.extra.' .. plugin,
        })
    end
end

require('lazy').setup({
    spec = specs,
    rocks = {enabled = false},
})

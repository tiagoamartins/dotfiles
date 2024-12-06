local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(lazypath) then
	print('Installing lazy.nvim...')
	vim.fn.system({
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable', -- latest stable release
		lazypath,
	})
end

-- add lazy to the `runtimepath`, so it can be used with `require`
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
	spec = {
		{import = 'plugins'}
	},
	ui = {
		icons = {
			ft = "▶ ",
			import = "◑ ",
			init = "α ",
			keys = "★ ",
			plugin = "⇒ ",
			require = "◊ ",
			runtime = "⌐ ",
			source = "▤ ",
		}
	}
})

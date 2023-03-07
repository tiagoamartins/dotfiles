local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
		vim.cmd [[packadd packer.nvim]]
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'

	-- lsp
	use {
		{
			'neovim/nvim-lspconfig',
			config = [[require('config.lsp')]]
		},
		{
			'adoyle-h/lsp-toggle.nvim',
			after = 'nvim-lspconfig',
			config = function()
				require('lsp-toggle').setup({
					create_cmds = true,
					telescope = true,
				})
			end
		},
		{
			'jose-elias-alvarez/null-ls.nvim',
			config = [[require('config.lint')]],
			event = 'InsertEnter',
			opt = true,
			requires = 'plenary.nvim',
			wants = 'LuaSnip'
		}
	}

	-- treesitter
	use {
		'nvim-treesitter/nvim-treesitter',
		config = [[require('config.treesitter')]],
		requires = {
			{'JoosepAlviste/nvim-ts-context-commentstring', after = 'nvim-treesitter'},
			{'nvim-treesitter/nvim-treesitter-context', after = 'nvim-treesitter'},
			{'nvim-treesitter/nvim-treesitter-refactor', after = 'nvim-treesitter'},
			{'nvim-treesitter/nvim-treesitter-textobjects', after = 'nvim-treesitter'}
		},
		run = function()
			local ts_update = require('nvim-treesitter.install').update({with_sync = true})
			ts_update()
		end
	}

	-- colors
	use 'tiagoamartins/vim-hybrid'

	-- completion
	use {
		'hrsh7th/nvim-cmp',
		config = [[require('config.completion')]],
		event = 'InsertEnter',
		requires = {
			{'f3fora/cmp-spell', after = 'nvim-cmp'},
			{'hrsh7th/cmp-buffer', after = 'nvim-cmp'},
			{'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp', requires = 'nvim-lspconfig'},
			{'hrsh7th/cmp-nvim-lsp-signature-help', after = 'nvim-cmp', requires = 'nvim-lspconfig'},
			{'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp'},
			{'hrsh7th/cmp-path', after = 'nvim-cmp'},
			{'jc-doyle/cmp-pandoc-references', after = 'nvim-cmp'},
			{'onsails/lspkind-nvim', before = 'nvim-cmp'},
			{'petertriho/cmp-git', after = 'nvim-cmp', requires = 'plenary.nvim'},
			{'quangnguyen30192/cmp-nvim-tags', after = 'nvim-cmp'},
			{'ray-x/cmp-treesitter', after = 'nvim-cmp', requires = 'nvim-treesitter'},
			{'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp', requires = 'LuaSnip'},
		},
		want = 'LuaSnip'
	}

	-- debbuging
	use {
		'mfussenegger/nvim-dap',
		cmd = { 'BreakpointToggle', 'Debug', 'DapREPL' },
		config = [[require('config.debug')]],
		requires = {
			{'rcarriga/nvim-dap-ui', after = 'nvim-dap', requires = 'nvim-dap'},
			{'theHamsta/nvim-dap-virtual-text', after = 'nvim-dap', requires = 'nvim-dap'}
		}
	}

	-- interface
	use {
		'godlygeek/tabular',
		cmd = 'Tabularize',
		ft = {'systemverilog', 'verilog', 'vhdl'},
		opt = true
	}
	use 'tpope/vim-apathy'
	use 'tpope/vim-commentary'
	use 'tpope/vim-repeat'
	use 'tpope/vim-speeddating'
	use 'tpope/vim-surround'
	use 'tpope/vim-unimpaired'

	-- plugins
	use 'igemnace/vim-makery'
	use 'tpope/vim-abolish'
	use {
		'tpope/vim-dispatch',
		cmd = {'Dispatch', 'Make', 'Focus', 'Start'},
		opt = true
	}
	use 'tpope/vim-fugitive'
	use 'tpope/vim-projectionist'
	use 'vim-test/vim-test'

	-- snippets
	use {
		'L3MON4D3/LuaSnip',
		config = [[require('config.snippets')]],
		opt = true
	}

	-- syntax
	use {'ARM9/arm-syntax-vim', ft = {'arm', 'armv4', 'armv5'}}
	use {'Glench/Vim-Jinja2-Syntax', ft = {'jinja'}}
	use {'Shirk/vim-gas', ft = {'gas'}}
	use {'WeiChungWu/vim-SystemVerilog', ft = {'systemverilog', 'verilog'}}
	use {'jvirtanen/vim-hcl', ft = {'hcl'}}
	use {'tpope/vim-git', ft = {'git', 'gitcommit', 'gitconfig', 'gitrebase', 'gitsendemail'}}

	-- interface
	use 'nvim-lua/plenary.nvim'
	use {
		'lewis6991/gitsigns.nvim',
		config = function() require('gitsigns').setup() end,
		requires = 'plenary.nvim'
	}

	use {
		'nvim-telescope/telescope.nvim',
		config = [[require('config.interface')]],
		tag = '0.1.x',
		requires = {
			{'plenary.nvim', before = 'telescope.nvim'},
			{'nvim-telescope/telescope-fzf-native.nvim', run = 'make'},
			{'keyvchan/telescope-find-pickers.nvim', module = 'telescope._extensions.find_pickers'},
			{'debugloop/telescope-undo.nvim', module = 'telescope._extensions.undo'},
		}
	}

	-- python
	use {'Vimjas/vim-python-pep8-indent', ft = {'python'}}
	use {'aliev/vim-compiler-python', ft = {'python'}}
	use {'vim-python/python-syntax', ft = {'python'}}

	if packer_bootstrap then
		require('packer').sync()
	end
end)

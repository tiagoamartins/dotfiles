return {
	{
		'godlygeek/tabular',
		cmd = 'Tabularize',
		ft = {'verilog', 'vhdl'},
	},
	{
		'igemnace/vim-makery',
		cmd = {'Makery', 'LM', 'M'},
	},
	{
		'tpope/vim-abolish',
		cmd = {'Abolish', 'S', 'Subvert'},
		keys = {'cr'}
	},
	{
		'tpope/vim-commentary',
		cmd = {'Commentary'},
		keys = {
			'gc',
			'gcc',
			'gcu',
			'gcgc',
			{'gc', mode = 'v'},
			{'gc', mode = 'o'},
		}
	},
	{
		'tpope/vim-dispatch',
		cmd = {'Dispatch', 'Make', 'Focus', 'FocusDispatch', 'Start'},
	},
	{
		'tpope/vim-fugitive',
		cmd = {
			'Gbrowse',
			'Gcd',
			'Gclog',
			'Gdiffsplit',
			'Gdrop',
			'Gedit',
			'Git',
			'GlLog',
			'Glcd',
			'Glgrep',
			'Gllog',
			'Gread',
			'Gsplit',
			'Gtabedit',
			'Gvdiffsplit',
			'Gvsplit',
			'Gwrite'
		},
	},
	'tpope/vim-projectionist',
	'tpope/vim-repeat',
	{
		'tpope/vim-speeddating',
		cmd = {'SpeedDatingFormat'},
		keys = {
			'<C-A>', 'd<C-A>', {'<C-A>', mode = 'v'},
			'<C-X>', 'd<C-X>', {'<C-X>', mode = 'v'}
		}
	},
	{
		'tpope/vim-surround',
		keys = {
			'ds',
			'cs', 'cS',
			'ys', 'yss',
			'yS', 'ySS',
			{'S', mode = 'v'},
			{'gS', mode = 'v'},
			{'<C-G>s', mode = 'i'},
			{'<C-S>', mode = 'i'}
		}
	},
	{
		'vim-test/vim-test',
		cmd = {
			'TestClass',
			'TestFile',
			'TestLast',
			'TestNearest',
			'TestSuite',
			'TestVisit'
		}
	},
	'tpope/vim-unimpaired'
}

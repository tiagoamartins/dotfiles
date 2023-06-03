return {
	'igemnace/vim-makery',
	'tpope/vim-abolish',
	{
		'tpope/vim-dispatch',
		cmd = {'Dispatch', 'Make', 'Focus', 'FocusDispatch', 'Start'},
	},
	{
		'tpope/vim-fugitive',
		cmd = {
			'Git', 'Gedit', 'Gtabedit', 'Gread', 'Gsplit', 'Gvsplit', 'Glcd', 'Glgrep',
			'Gllog', 'GlLog', 'Gdiffsplit', 'Gvdiffsplit', 'Gclog', 'Gcd', 'Gbrowse', 'Gdrop',
			'Gwrite'
		},
	},
	'tpope/vim-projectionist',
	{
		'vim-test/vim-test',
		cmd = {'TestClass', 'TestFile', 'TestLast', 'TestNearest', 'TestSuite', 'TestVisit'},
	}
}

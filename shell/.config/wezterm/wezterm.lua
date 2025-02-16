local wezterm = require('wezterm')

local config = wezterm.config_builder()

config.colors = {
	foreground = '#C5C8C6',
	background = '#1D1F21',

	ansi = {
		'#282A2E',
		'#A54242',
		'#8C9440',
		'#DE935F',
		'#5F819D',
		'#85678F',
		'#5E8D87',
		'#707880',
	},
	brights = {
		'#373B41',
		'#CC6666',
		'#B5BD68',
		'#F0C674',
		'#81A2BE',
		'#B294BB',
		'#8ABEB7',
		'#C5C8C6',
	},
}

config.font = wezterm.font_with_fallback({
    {family = 'Terminus', weight = 'Regular'},
    {family = 'Terminess Nerd Font', weight = 'Medium'}
})
config.font_size = 12
config.enable_tab_bar = false
config.enable_scroll_bar = false
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0
}
config.window_frame = {
	font = wezterm.font({family = 'Terminus', weight = 'Regular'}),
	font_size = 12,
	inactive_titlebar_bg = '#303030',
	active_titlebar_bg = '#282A2E',
	inactive_titlebar_fg = '#777777',
	active_titlebar_fg = '#C5C8C6'
}
config.window_decorations = 'RESIZE'
config.disable_default_key_bindings = true
config.warn_about_missing_glyphs = false

return config

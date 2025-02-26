local wezterm = require('wezterm')
local config = wezterm.config_builder()
local is_linux <const> = wezterm.target_triple:find("linux") ~= nil

config.colors = {
    foreground = '#C5C8C6',
    background = '#1D1F21',
    visual_bell = '#303030',

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

local font_size = is_linux and 12 or 16
local font_primary = is_linux and 'Terminus' or 'Terminus (TTF)'
local font_fallback = 'Terminess Nerd Font'

config.font = wezterm.font_with_fallback({
    {family = font_primary, weight = 'Regular'},
    {family = font_fallback, weight = 'Medium'}
})
config.font_size = font_size
config.enable_tab_bar = false
config.enable_scroll_bar = false
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0
}
config.window_frame = {
    font = wezterm.font({family = font_primary, weight = 'Regular'}),
    font_size = font_size,
    inactive_titlebar_bg = '#303030',
    active_titlebar_bg = '#282A2E',
    inactive_titlebar_fg = '#777777',
    active_titlebar_fg = '#C5C8C6'
}
config.window_decorations = is_linux and 'RESIZE' or 'TITLE | RESIZE'
config.disable_default_key_bindings = true
config.warn_about_missing_glyphs = false

config.audible_bell = 'Disabled'
config.visual_bell = {
    fade_in_function = 'EaseIn',
    fade_in_duration_ms = 50,
    fade_out_function = 'EaseOut',
    fade_out_duration_ms = 50,
}

config.keys = {
    {
        key = 'V',
        mods = 'CTRL',
        action = wezterm.action.PasteFrom('PrimarySelection')
    },
    {
        key = 'C',
        mods = 'CTRL',
        action = wezterm.action.CopyTo('PrimarySelection')
    },
    {
        key = '-',
        mods = 'CTRL',
        action = wezterm.action.DecreaseFontSize
    },
    {
        key = '=',
        mods = 'CTRL',
        action = wezterm.action.IncreaseFontSize
    },
    {
        key = '0',
        mods = 'CTRL',
        action = wezterm.action.ResetFontSize
    },
}

return config

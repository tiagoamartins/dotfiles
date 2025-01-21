local pallete = {
    white = {
        gui = '#c6c6c6',
        cterm = 251
    },
    grey234 = {
        gui = '#1c1c1c',
        cterm = 234
    },
    green = {
        gui = '#b5bd68',
        cterm = 10
    },
    blue = {
        gui = '#81a2be',
        cterm = 12
    },
    purple = {
        gui = '#b294bb',
        cterm = 13
    },
    red = {
        gui = '#cc6666',
        cterm = 9
    },
    orange = {
        gui = '#de935f',
        cterm = 3
    },
    fallback_bg = {
        gui = '#303030',
        cterm = 236
    }
}

local function set_colors(gname, bg, fg)
    vim.api.nvim_set_hl(0, gname, {
        fg = fg.gui,
        bg = bg.gui,
        ctermfg = fg.cterm,
        ctermbg = bg.cterm
    })
end

local function statusline(active)
    if vim.bo.buftype == 'nofile' or vim.bo.filetype == 'netrw' then
        -- probably a file explorer
        vim.wo.statusline="%!v:lua.require'statusline'.statusline_no_file_status_line()"
    elseif vim.bo.buftype == 'nowrite' then
        -- no custom status line for special windows
        return
    elseif active then
        vim.wo.statusline="%!v:lua.require'statusline'.statusline_active_status_line()"
    else
        vim.wo.statusline="%!v:lua.require'statusline'.statusline_inactive_status_line()"
    end
end

-- update the status line for all inactive windows
--
-- this is needed when starting Vim with multiple splits, for example 'vim -O
-- file1 file2', otherwise all 'status lines will be rendered as if they are
-- active. Inactive statuslines are usually rendered via the WinLeave and
-- BufLeave events, but those events are not triggered when starting Vim.
--
-- note - https://jip.dev/posts/a-simpler-vim-statusline/#inactive-statuslines
local function update_inactive_windows()
    for winnum=1,vim.fn.winnr('$') do
        if winnum ~= vim.fn.winnr() then
            vim.api.nvim_set_option_value(
                'statusline', "%!v:lua.require'statusline'.statusline_inactive_status_line()", {
                    scope = 'local',
                    win = vim.fn.win_getid(winnum)
                }
            )
        end
    end
end

local function user_colors()
    local bg = {
        gui = '',
        cterm = ''
    }

    -- leverage existing 'colorscheme' StatusLine colors taking into account
    -- the 'reverse' option.
    if vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID('StatusLine')), 'reverse', 'cterm') == 1 then
        bg.cterm = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID('StatusLine')), 'fg', 'cterm')
    else
        bg.cterm = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID('StatusLine')), 'bg', 'cterm')
    end

    if vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID('StatusLine')), 'reverse', 'gui') == 1 then
        bg.gui = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID('StatusLine')), 'fg', 'gui')
    else
        bg.gui = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID('StatusLine')), 'bg', 'gui')
    end

    -- fallback to statusline colors when the current color scheme does not
    -- define StatusLine colors.
    if bg.cterm ~= '' then
        bg.cterm = pallete.fallback_bg.cterm
    end
    if bg.gui ~= '' then
        bg.gui = pallete.fallback_bg.gui
    end

    -- set user colors that will be used to color certain sections of the
    -- status line.
    set_colors('User1', pallete.blue, pallete.grey234)
    set_colors('User2', pallete.green, pallete.grey234)
    set_colors('User3', pallete.purple, pallete.grey234)
    set_colors('User4', pallete.red, pallete.grey234)
    set_colors('User5', bg, pallete.blue)
    set_colors('User6', bg, pallete.green)
    set_colors('User7', pallete.purple, pallete.grey234)
    set_colors('User8', bg, pallete.orange)
    set_colors('User9', pallete.red, pallete.grey234)
end

vim.api.nvim_create_augroup('my_status_line_events', {clear = true})
vim.api.nvim_create_autocmd({'CursorHold', 'BufWritePost'}, {
    group = 'my_status_line_events',
    pattern = '*',
    callback = function ()
        vim.b.statusline_whitespace_warning = nil
    end
})
vim.api.nvim_create_autocmd('VimEnter', {
    group = 'my_status_line_events',
    pattern = '*',
    callback = update_inactive_windows
})
vim.api.nvim_create_autocmd({'ColorScheme', 'SourcePre'}, {
    group = 'my_status_line_events',
    pattern = '*',
    callback = user_colors
})
vim.api.nvim_create_autocmd({'WinEnter', 'BufWinEnter'}, {
    group = 'my_status_line_events',
    pattern = '*',
    callback = function ()
        statusline(true)
    end
})
vim.api.nvim_create_autocmd('WinLeave', {
    group = 'my_status_line_events',
    pattern = '*',
    callback = function ()
        statusline(false)
    end
})
vim.api.nvim_create_autocmd('CmdlineEnter', {
    group = 'my_status_line_events',
    pattern = '*',
    callback = function ()
        statusline(true)
        vim.cmd.redraw()
    end
})

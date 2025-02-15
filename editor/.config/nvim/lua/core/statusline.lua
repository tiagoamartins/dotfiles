local M = {}

M.pallete = {
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

M.mode_list = {
    ['n']       = {'%1*', 'normal'},
    ['no']      = {'%1*', 'normal·operator pending'},
    ['v']       = {'%3*', 'visual'},
    ['V']       = {'%3*', 'v·line'},
    ['<C-V>']   = {'%3*', 'v·block'},
    ['s']       = {'%3*', 'select'},
    ['S']       = {'%3*', 's·line'},
    ['<C-S>']   = {'%3*', 's·block'},
    ['i']       = {'%2*', 'insert'},
    ['R']       = {'%4*', 'replace'},
    ['Rv']      = {'%4*', 'v·replace'},
    ['c']       = {'%2*', 'command'},
    ['cv']      = {'%2*', 'vim ex'},
    ['ce']      = {'%2*', 'ex'},
    ['r']       = {'%2*', 'prompt'},
    ['rm']      = {'%2*', 'more'},
    ['r?']      = {'%2*', 'confirm'},
    ['!']       = {'%2*', 'shell'},
    ['t']       = {'%2*', 'terminal'}
}

function M.block_append(fn_name, text)
    if not text or text == '' then
        return ''
    end

    local func = M[fn_name]

    if func() == '' then
        return ''
    end

    return text
end

function M.block(text, modifier, lpad, rpad)
    lpad = lpad or ''
    rpad = rpad or ''

    if type(lpad) == 'number' then
        lpad = string.rep(' ', lpad)
    end

    if type(rpad) == 'number' then
        rpad = string.rep(' ', rpad)
    end

    if type(text) ~= 'string' then
        vim.fn.throw('statusline: wrong argument type for "text"')
        return
    end

    if text:sub(1, 2) == 'f:' then
        local fn_name = text:sub(3, #text)

        raw = "%{v:lua.require'core.statusline'." .. fn_name .. '()}'
        lpad = "%{v:lua.require'core.statusline'.block_append('" .. fn_name .. "', '" .. lpad .. "')}"
        rpad = "%{v:lua.require'core.statusline'.block_append('" .. fn_name .. "', '" .. rpad .. "')}"
    else
        raw = text
    end

    if not raw or raw == '' then
        return ''
    end

    if modifier or modifier ~= '' then
        text = modifier .. raw

        if modifier:find('%%%d%*') then
            text = text .. '%*'
        end
    else
        text = raw
    end

    return lpad .. text .. rpad
end

function M.file_icon()
    if (vim.g.statusline_nerd_icon and vim.g.statusline_nerd_icon ~= 0) or vim.api.nvim_buf_get_name(0) == '' then
        return ''
    end

    if vim.g.nvim_web_devicons then
        if not require('nvim-web-devicons').has_loaded() then
            return ''
        end
        return require('nvim-web-devicons').get_icon(
            vim.fn.expand('%'),
            vim.fn.expand('%:e')
        ) .. ' '
    elseif vim.g.loaded_webdevicons then
        return vim.fn.WebDevIconsGetFileTypeSymbol() .. ' '
    else
        return ''
    end
end

function M.short_file_path(path)
    if not path or path == '' then
        return ''
    end

    local sep = '/'

    if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
        sep = '\\'
    end

    local fpath = vim.fn.pathshorten(vim.fn.fnamemodify(path, ':~:.'))

    local comp = {}
    local n_comp = 0

    for str in string.gmatch(fpath, '([^' .. sep .. ']+)') do
        table.insert(comp, str)
        n_comp = n_comp + 1
    end

    if n_comp > 4 then
        return '...' .. sep .. table.concat(comp, sep, n_comp - 3)
    else
        return fpath
    end
end

function M.whitespace_check()
    -- mixed indent, bad expandtab or trailing spaces warning,
    -- see <https://github.com/millermedeiros/vim-statline>.
    if vim.b.statusline_whitespace_warning then
        return vim.b.statusline_whitespace_warning
    end

    local msg = ''

    if vim.bo.modifiable then
        local tabs = vim.fn.search('^\\t', 'nw') > 0
        local spaces = vim.fn.search('^ \\{' .. vim.bo.tabstop .. ',}', 'nw') > 0

        if (tabs and spaces) or (vim.fn.search('^ \\+\\t\\+', 'nw') > 0) then
            msg = 'mixed'
        elseif spaces and not vim.bo.expandtab then
            msg = 'noexpandtab'
        elseif tabs and vim.bo.expandtab then
            msg = 'expandtab'
        end

        if vim.fn.search('\\s\\+$', 'nw') > 0 then
            msg = (msg and msg ~= '') and (msg .. ',trails') or 'trails'
        end
    end

    return msg
end

function M.statusline_mode(mode)
    color, text = unpack(M.mode_list[mode] or {'%1*', 'normal'})
    return M.block(' ' .. text .. ' ', color)
end

function M.statusline_file()
    local file = ''

    if vim.bo.buftype ~= '' then
        file = vim.fn.expand('%:t')
    else
        file = M.short_file_path(vim.fn.expand('%'))
    end

    return M.file_icon() .. file
end

function M.statusline_flags()
    local flags = {}
    if vim.bo.modifiable and vim.bo.modified then
        table.insert(flags, '+')
    end

    if vim.bo.readonly then
        table.insert(flags, 'RO')
    end

    return table.concat(flags, ' ')
end

function M.statusline_git_branch()
    if (vim.g.statusline_git and vim.g.statusline_git ~= 0)
       or not vim.g.loaded_fugitive then
        return ''
    end

    return vim.fn.FugitiveHead()
end

-- find out current buffer's size and output it
function M.statusline_file_size()
    local bytes = vim.fn.getfsize(vim.fn.expand('%:p'))
    local kbytes = 0
    local mbytes = 0

    if bytes >= 1024 then
        kbytes = bytes / 1024
    end

    if kbytes >= 1024 then
        mbytes = kbytes / 1024
    end

    if bytes <= 0 then
        return '0'
    end

    if mbytes > 0 then
        return math.floor(mbytes + 0.5) .. 'MB'
    elseif kbytes > 0 then
        return math.floor(kbytes + 0.5) .. 'KB'
    else
        return math.floor(bytes + 0.5) .. 'B'
    end
end

function M.statusline_plugins()
    local status = {}

    local whitespace = M.whitespace_check()
    if whitespace ~= '' then
        table.insert(status, M.block(' ' .. whitespace .. ' ', '%7*'))
    end

    -- neovim LSP diagnostics indicator
    local warnings = #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.WARN})
    if warnings > 0 then
        table.insert(status, M.block('warning [' .. warnings .. ']', '%8*'))
    end

    local errors = #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.ERROR})
    if errors > 0 then
        table.insert(status, M.block(' error [' .. errors .. '] ', '%9*'))
    end

    return table.concat(status, ' | ')
end

function M.statusline_active_status_line()
    local statusline = ''

    statusline = statusline .. M.statusline_mode(vim.fn.mode())
    statusline = statusline .. '%<'
    statusline = statusline .. M.block('f:statusline_file', '', 1)
    statusline = statusline .. M.block('f:statusline_flags', '%5*', 1)
    statusline = statusline .. M.block('f:statusline_git_branch', '%6*', '  [', ']')
    statusline = statusline .. '%='
    statusline = statusline .. '%{&filetype}' -- filetype
    statusline = statusline .. " | %{&fenc != '' ? &fenc : &enc}[%{&ff}]" -- encoding & fileformat
    statusline = statusline .. " | %l:%c | %{v:lua.require'core.statusline'.statusline_file_size()} | %p%%"

    local plugins = M.statusline_plugins()
    if plugins ~= '' then
        statusline = statusline .. ' | ' .. plugins
    end

    statusline = statusline .. ' '

    return statusline
end

function M.statusline_inactive_status_line()
    local statusline = ''

    statusline = statusline .. '%<'
    statusline = statusline .. M.block('f:statusline_file', '', 1)
    statusline = statusline .. M.block('f:statusline_flags', '', 1)
    statusline = statusline .. "%=%l:%c | %{v:lua.require'core.statusline'.statusline_file_size()} | %p%% "

    return statusline
end

function M.statusline_short_current_path()
    return vim.fn.pathshorten(vim.fn.fnamemodify(vim.fn.getcwd(), ':~:.'))
end

function M.statusline_no_file_status_line()
    return "%{v:lua.require'core.statusline'.statusline_short_current_path()}"
end

function M.set_colors(gname, bg, fg)
    vim.api.nvim_set_hl(0, gname, {
        fg = fg.gui,
        bg = bg.gui,
        ctermfg = fg.cterm,
        ctermbg = bg.cterm
    })
end

function M.draw(active)
    if vim.bo.buftype == 'nofile' or vim.bo.filetype == 'netrw' then
        -- probably a file explorer
        vim.wo.statusline="%!v:lua.require'core.statusline'.statusline_no_file_status_line()"
    elseif vim.bo.buftype == 'nowrite' then
        -- no custom status line for special windows
        return
    elseif active then
        vim.wo.statusline="%!v:lua.require'core.statusline'.statusline_active_status_line()"
    else
        vim.wo.statusline="%!v:lua.require'core.statusline'.statusline_inactive_status_line()"
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
function M.update_inactive_windows()
    for winnum=1,vim.fn.winnr('$') do
        if winnum ~= vim.fn.winnr() then
            vim.api.nvim_set_option_value(
                'statusline', "%!v:lua.require'core.statusline'.statusline_inactive_status_line()", {
                    scope = 'local',
                    win = vim.fn.win_getid(winnum)
                }
            )
        end
    end
end

function M.user_colors()
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
        bg.cterm = M.pallete.fallback_bg.cterm
    end
    if bg.gui ~= '' then
        bg.gui = M.pallete.fallback_bg.gui
    end

    -- set user colors that will be used to color certain sections of the
    -- status line.
    M.set_colors('User1', M.pallete.blue, M.pallete.grey234)
    M.set_colors('User2', M.pallete.green, M.pallete.grey234)
    M.set_colors('User3', M.pallete.purple, M.pallete.grey234)
    M.set_colors('User4', M.pallete.red, M.pallete.grey234)
    M.set_colors('User5', bg, M.pallete.blue)
    M.set_colors('User6', bg, M.pallete.green)
    M.set_colors('User7', M.pallete.purple, M.pallete.grey234)
    M.set_colors('User8', bg, M.pallete.orange)
    M.set_colors('User9', M.pallete.red, M.pallete.grey234)
end

function M.setup()
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
        callback = M.update_inactive_windows
    })
    vim.api.nvim_create_autocmd({'ColorScheme', 'SourcePre'}, {
        group = 'my_status_line_events',
        pattern = '*',
        callback = M.user_colors
    })
    vim.api.nvim_create_autocmd({'WinEnter', 'BufWinEnter'}, {
        group = 'my_status_line_events',
        pattern = '*',
        callback = function ()
            M.draw(true)
        end
    })
    vim.api.nvim_create_autocmd('WinLeave', {
        group = 'my_status_line_events',
        pattern = '*',
        callback = function ()
            M.draw(false)
        end
    })
    vim.api.nvim_create_autocmd('CmdlineEnter', {
        group = 'my_status_line_events',
        pattern = '*',
        callback = function ()
            M.draw(true)
            vim.cmd.redraw()
        end
    })
end

return M

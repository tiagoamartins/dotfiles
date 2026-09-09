local hl = function(group)
    return vim.api.nvim_get_hl(0, {
        name = group,
        link = false,
        create = false,
    })
end

local set_hl_groups = function()
    local base = hl('StatusLine')

    for group, opts in pairs({
        ModeNormal = {fg = base.bg, bg = base.fg},
        ModePending = {fg = base.bg, bg = hl('Comment').fg},
        ModeVisual = {fg = base.bg, bg = hl('SpecialKey').fg},
        ModeInsert = {fg = base.bg, bg = hl('DiffAdded').fg},
        ModeCommand = {fg = base.bg, bg = hl('Number').fg},
        ModeReplace = {fg = base.bg, bg = hl('Constant').fg},
        Other = {link = 'StatusLine'},
        Bold = {bold = true},
        Dim = {fg = hl('LineNr').fg, bg = base.bg},
        Info = {fg = base.bg, bg = hl('DiagnosticInfo').fg},
        Warn = {fg = hl('DiagnosticWarn').fg, bg = hl('VertSplit').bg},
        Err = {fg = base.bg, bg = hl('DiagnosticError').fg},
        Flags = {fg = hl('Title').fg, bg = hl('VertSplit').bg},
        Vcs = {fg = hl('OkMsg').fg, bg = hl('FloatTitle').bg},
    }) do
        group = 'StatusLine' .. group
        vim.api.nvim_set_hl(0, group, opts)
        opts.fg, opts.bg = opts.bg, opts.fg
        vim.api.nvim_set_hl(0, group .. 'Inverted', opts)
    end
end

local shortpath = function(path)
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

local mode = function()
    local mode_list = {
        ['n']     = {name = 'normal',     hl = 'Normal'},
        ['no']    = {name = 'op·pending', hl = 'Pending'},
        ['nov']   = {name = 'op·pending', hl = 'Pending'},
        ['noV']   = {name = 'op·pending', hl = 'Pending'},
        ['no\22'] = {name = 'op·pending', hl = 'Pending'},
        ['niI']   = {name = 'normal',     hl = 'Normal'},
        ['niR']   = {name = 'normal',     hl = 'Normal'},
        ['niV']   = {name = 'normal',     hl = 'Normal'},
        ['nt']    = {name = 'normal',     hl = 'Normal'},
        ['ntT']   = {name = 'normal',     hl = 'Normal'},
        ['v']     = {name = 'visual',     hl = 'Visual'},
        ['vs']    = {name = 'visual',     hl = 'Visual'},
        ['V']     = {name = 'v·line',     hl = 'Visual'},
        ['Vs']    = {name = 'v·line',     hl = 'Visual'},
        ['\22']   = {name = 'v·block',    hl = 'Visual'},
        ['\22s']  = {name = 'v·block',    hl = 'Visual'},
        ['s']     = {name = 'select',     hl = 'Insert'},
        ['S']     = {name = 's·line',     hl = 'Normal'},
        ['\19']   = {name = 's·block',    hl = 'Normal'},
        ['i']     = {name = 'insert',     hl = 'Insert'},
        ['ic']    = {name = 'insert',     hl = 'Insert'},
        ['ix']    = {name = 'insert',     hl = 'Insert'},
        ['R']     = {name = 'replace',    hl = 'Replace'},
        ['Rc']    = {name = 'replace',    hl = 'Replace'},
        ['Rx']    = {name = 'replace',    hl = 'Replace'},
        ['Rv']    = {name = 'v·replace',  hl = 'Replace'},
        ['Rvc']   = {name = 'v·replace',  hl = 'Replace'},
        ['Rvx']   = {name = 'v·replace',  hl = 'Replace'},
        ['c']     = {name = 'command',    hl = 'Command'},
        ['cr']    = {name = 'command',    hl = 'Command'},
        ['cv']    = {name = 'vim ex',     hl = 'Command'},
        ['cvr']   = {name = 'vim ex',     hl = 'Command'},
        ['r']     = {name = 'prompt',     hl = 'Normal'},
        ['rm']    = {name = 'more',       hl = 'Normal'},
        ['r?']    = {name = 'confirm',    hl = 'Normal'},
        ['!']     = {name = 'shell',      hl = 'Normal'},
        ['t']     = {name = 'terminal',   hl = 'Command'},
    }

    local mode = mode_list[vim.fn.mode()] or {name = 'UNKNOWN', hl = 'Other'}

    return table.concat({
        '%#StatusLineMode' .. mode.hl .. '#',
        ' ',
        mode.name,
        ' ',
        '%*'
    })
end

local icon = function()
    if vim.g.nvim_web_devicons == nil or vim.api.nvim_buf_get_name(0) == '' then
        return ''
    end

    local devicons = require('nvim-web-devicons')
    local name = vim.fn.expand('%')
    local ext = vim.fn.expand('%:e')
    local icon = devicons.get_icon(name, ext)
    return icon and ' ' .. icon or ''
end

local filepath = function()
    local file = vim.fn.expand('%:t')
    local path = vim.fn.expand('%')

    if path:sub(1, 11) == 'fugitive://' then
        local dir = vim.fn.fnamemodify(path:sub(12, #path - 1), ':~:h:h:.')
        return (' ' .. dir) or ''
    elseif path:sub(1, 6) == 'oil://' then
        local dir = vim.fn.fnamemodify(path:sub(7, #path - 1), ':~:.')
        return (' ' .. dir) or ''
    end

    return ' ' .. (vim.bo.buftype ~= '' and file or shortpath(path))
end

local filetype = function()
    return vim.bo.filetype ~= '' and '%{&filetype} | ' or ''
end

local flags = function()
    local symbols = table.concat({
        vim.bo.readonly and 'RO' or '',
        vim.bo.modifiable and vim.bo.modified and '+' or '',
        not vim.bo.modifiable and '-' or '',
    })

    return symbols ~= '' and ' %#StatusLineFlags#' .. symbols .. '%*' or ''
end

local vcs = function()
    if (vim.g.statusline_git and vim.g.statusline_git ~= 0)
       or not vim.g.loaded_fugitive or vim.bo.filetype == 'oil' then
        return ''
    end

    local head = vim.fn.FugitiveHead()
    return head ~= '' and ' [%#StatusLineVcs#' .. head .. '%*]' or ''
end

-- find out current buffer's size and output it
local filesize = function()
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
        return ''
    end

    if mbytes > 0 then
        return math.floor(mbytes + 0.5) .. 'MB | '
    elseif kbytes > 0 then
        return math.floor(kbytes + 0.5) .. 'KB | '
    else
        return math.floor(bytes + 0.5) .. 'B | '
    end
end

local whitespace = function()
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

local encoding = function()
    if vim.bo.filetype == 'oil' then
        return ''
    end

    return "%{&fenc != '' ? &fenc : &enc}[%{&ff}] | "
end

local plugins = function()
    local spaces = whitespace()
    local warns = #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.WARN})
    local errors = #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.ERROR})

    return table.concat({
        spaces ~= '' and ' | %#StatusLineInfo# ' .. spaces .. ' %*' or '',
        warns > 0 and ' | %#StatusLineWarn#warning [' .. warns .. ']%*' or '',
        errors > 0 and ' | %#StatusLineErr# error [' .. errors .. '] %*' or '',
    })
end

vim.opt.statusline = "%{%v:lua.require'core.statusline'.render()%}"

return {
    set_hl_groups = set_hl_groups,
    render = function()
        local active = vim.api.nvim_get_current_win()
        local status = tonumber(vim.g.actual_curwin or -1)

        if vim.api.nvim_win_get_config(active).relative ~= '' then
            -- no custom status line for floating windows
            return ''
        elseif vim.bo.buftype == 'nofile' or vim.bo.filetype == 'netrw' then
            -- probably a file explorer
            return shortpath(vim.fn.getcwd())
        elseif vim.bo.buftype == 'nowrite' then
            -- no custom status line for special windows
            return table.concat({
                '%<',
                filepath(),
                flags(),
            })
        elseif vim.bo.buftype == 'quickfix' then
            return 'quickfix'
        elseif status ~= active then
            return table.concat({
                '%<',
                filepath(),
                flags(),
                '%=',
                '%l:%c | ',
                filesize(),
                '%p%%',
                ' ',
            })
        end

        return table.concat({
            mode(),
            '%<',
            icon(),
            filepath(),
            flags(),
            vcs(),
            '%=',
            filetype(),
            encoding(),
            '%l:%c | ',
            filesize(),
            '%p%%',
            plugins(),
            ' ',
        })
    end
}

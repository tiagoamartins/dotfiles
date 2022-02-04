let s:modes = {
            \ 'n':      ['%1*', 'normal'],
            \ 'no':     ['%1*', 'normal·operator pending'],
            \ 'v':      ['%3*', 'visual'],
            \ 'V':      ['%3*', 'v·line'],
            \ "\<C-V>": ['%3*', 'v·block'],
            \ 's':      ['%3*', 'select'],
            \ 'S':      ['%3*', 's·line'],
            \ "\<C-S>": ['%3*', 's·block'],
            \ 'i':      ['%2*', 'insert'],
            \ 'R':      ['%4*', 'replace'],
            \ 'Rv':     ['%4*', 'v·replace'],
            \ 'c':      ['%2*', 'command'],
            \ 'cv':     ['%2*', 'vim ex'],
            \ 'ce':     ['%2*', 'ex'],
            \ 'r':      ['%2*', 'prompt'],
            \ 'rm':     ['%2*', 'more'],
            \ 'r?':     ['%2*', 'confirm'],
            \ '!':      ['%2*', 'shell'],
            \ 't':      ['%2*', 'terminal']
            \}

function! s:TestFuncValid(func, text) abort
    if !strlen(a:text)
        return ''
    end

    return '%{strlen(' . string(a:func) . "()) ? '" . a:text . "' : ''}"
endfunction

function! s:Block(text, modifier, ...) abort
    let l:t_int = exists('v:t_int') ? v:t_int : type(1)
    let l:t_func = exists('v:t_func') ? v:t_func : type(function('type'))
    let l:t_string = exists('v:t_string') ? v:t_string : type('')
    let l:lpad = get(a:, 1, 0)
    let l:rpad = get(a:, 2, 0)

    if type(l:lpad) == l:t_int
        let l:lpad = repeat(' ', l:lpad)
    end
    if type(l:rpad) == l:t_int
        let l:rpad = repeat(' ', l:rpad)
    end

    if type(a:text) == l:t_func
        let l:raw = '%{' . string(a:text) . '()}'
        let l:lpad = s:TestFuncValid(a:text, l:lpad)
        let l:rpad = s:TestFuncValid(a:text, l:rpad)
    elseif type(a:text) == l:t_string
        let l:raw = a:text
    else
        throw 'statusline: wrong argument type for a:text'
    endif

    if !strlen(l:raw)
        return ''
    endif

    if strlen(a:modifier)
        let l:text = a:modifier . l:raw

        if a:modifier =~# '%\d\*'
            let l:text .= '%*'
        end
    else
        let l:text = l:raw
    end

    return l:lpad . l:text . l:rpad
endfunction

function! s:BlockFunc(func, modifier, ...) abort
    return call('s:Block', [function(a:func), a:modifier] + a:000)
endfunction

function! s:FileIcon() abort
    if !get(g:, 'statusline_nerd_icon', 0) || bufname('%') == ''
        return ''
    endif

    if exists('g:nvim_web_devicons')
        return luaeval("require'nvim-web-devicons'.get_icon(vim.fn.expand('%'), vim.fn.expand('%:e'))") . ' '
    elseif exists('g:loaded_webdevicons')
        return WebDevIconsGetFileTypeSymbol() . ' '
    else
        return ''
    endif
endfunction

function! s:ShortFilePath(path) abort
    if len(a:path) == 0
        return ''
    else
        let l:separator = '/'
        if has('win32') || has('win64')
            let l:separator = '\'
        endif

        let l:path = pathshorten(fnamemodify(a:path, ':~:.'))
        let l:components = split(l:path, l:separator)
        let l:n_components = len(l:components)

        if l:n_components > 4
            return '...' . l:separator . join(l:components[l:n_components - 4:], l:separator)
        else
            return l:path
        endif
    endif
endfunction

function! s:WhitespaceCheck() abort
    " Mixed indent, bad expandtab or trailing spaces warning, see <https://github.com/millermedeiros/vim-statline>.
    if !exists('b:statusline_whitespace_warning')
        let l:warning = ''

        if &modifiable
            let l:tabs = search('^\t', 'nw') > 0
            let l:spaces = search('^ \{' . &tabstop . ',}', 'nw') > 0

            if (l:tabs && l:spaces) || (search('^ \+\t\+', 'nw') > 0)
                let l:warning = 'mixed'
            elseif l:spaces && !&expandtab
                let l:warning = 'noexpandtab'
            elseif l:tabs && &expandtab
                let l:warning = 'expandtab'
            endif

            if search('\s\+$', 'nw') > 0
                let l:warning = strlen(l:warning) ? l:warning . ',trails' : 'trails'
            endif
        endif

        let b:statusline_whitespace_warning = l:warning
    endif

    return b:statusline_whitespace_warning
endfunction

function! statusline#Mode(mode) abort
    let [l:color, l:text] = get(s:modes, a:mode, ['%1*', 'normal'])
    return s:Block(' ' . l:text . ' ', l:color)
endfunction

function! statusline#File() abort
    if &buftype != ''
        let l:file = expand('%:t')
    else
        let l:file = s:ShortFilePath(expand('%'))
    endif

    return s:FileIcon() . l:file
endfunction

function! statusline#Flags() abort
    let l:flags = []
    if (&modifiable && &modified)
        call add(l:flags, '+')
    endif

    if &readonly
        call add(l:flags, 'RO')
    endif

    return join(l:flags)
endfunction

function! statusline#GitBranch() abort
    if !get(g:, 'statusline_git', 1) || !exists('g:loaded_fugitive')
        return ''
    endif

    return fugitive#head()
endfunction

" Find out current buffer's size and output it
function! statusline#FileSize()
    let bytes = getfsize(expand('%:p'))

    if (bytes >= 1024)
        let kbytes = bytes / 1024
    endif
    if (exists('kbytes') && kbytes >= 1024)
        let mbytes = kbytes / 1024
    endif

    if bytes <= 0
        return '0'
    endif

    if (exists('mbytes'))
        return mbytes . 'MB'
    elseif (exists('kbytes'))
        return kbytes . 'KB'
    else
        return bytes . 'B'
    endif
endfunction

function! statusline#Plugins() abort
    let l:status = []

    let l:whitespace = s:WhitespaceCheck()
    if strlen(l:whitespace)
        call add(l:status, s:Block(' ' . l:whitespace . ' ', '%7*'))
    endif

    " Neovim LSP diagnostics indicator
    if has('nvim-0.5')
        let l:warnings = luaeval('#vim.diagnostic.get(0, {severity=vim.diagnostic.severity.WARN})')
        if l:warnings > 0
            call add(l:status, s:Block('warning [' . l:warnings . ']', '%8*'))
        endif

        let l:errors = luaeval('#vim.diagnostic.get(0, {severity=vim.diagnostic.severity.ERROR})')
        if l:errors > 0
            call add(l:status, s:Block(' error [' . l:errors . '] ', '%9*'))
        endif
    endif

    return join(l:status, ' | ')
endfunction

function! statusline#ActiveStatusLine() abort
    let l:statusline = statusline#Mode(mode())
    let l:statusline .= '%<'
    let l:statusline .= s:BlockFunc('statusline#File', '', 1)
    let l:statusline .= s:BlockFunc('statusline#Flags', '%5*', 1)
    let l:statusline .= s:BlockFunc('statusline#GitBranch', '%6*', '  [', ']')
    let l:statusline .= '%='
    let l:statusline .= '%{&filetype}' " FileType
    let l:statusline .= " | %{&fenc != '' ? &fenc : &enc}[%{&ff}]" " Encoding & Fileformat
    let l:statusline .= ' | %l:%c | %{statusline#FileSize()} | %p%%'

    let l:plugins = statusline#Plugins()
    if strlen(l:plugins)
        let l:statusline .= ' | ' . l:plugins
    endif

    let l:statusline .= ' '

    return l:statusline
endfunction

function! statusline#InactiveStatusLine() abort
    let l:statusline = '%<'
    let l:statusline .= s:BlockFunc('statusline#File', '', 1)
    let l:statusline .= s:BlockFunc('statusline#Flags', '', 1)
    let l:statusline .= '%=%l:%c | %{statusline#FileSize()} | %p%% '

    return l:statusline
endfunction

function! statusline#ShortCurrentPath() abort
    return pathshorten(fnamemodify(getcwd(), ':~:.'))
endfunction

function! statusline#NoFileStatusLine() abort
    return '%{statusline#ShortCurrentPath()}'
endfunction

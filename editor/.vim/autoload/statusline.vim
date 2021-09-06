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

function! s:Block(text, modifier, ...) abort
    let l:t_func = exists('v:t_func') ? v:t_func : type(function('type'))
    let l:t_string = exists('v:t_string') ? v:t_string : type('')
    let l:pad_left = repeat(' ', get(a:, 1, 0))
    let l:pad_right = repeat(' ', get(a:, 2, 0))

    if type(a:text) == l:t_func
        let l:text_raw = a:text()
    elseif type(a:text) == l:t_string
        let l:text_raw = a:text
    else
        throw 'statusline: wrong argument type for a:text'
    endif

    if strlen(l:text_raw)
        let l:text = l:pad_left . l:text_raw . l:pad_right
    else
        return ''
    endif

    if type(a:modifier) == l:t_func
        let l:modifier = a:modifier(l:text)
    elseif type(a:modifier) == l:t_string
        let l:modifier = a:modifier
    else
        throw 'statusline: wrong argument type for a:modifier'
    endif

    return strlen(l:modifier) ? l:modifier . l:text . '%*' : l:text
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

function! s:WhitespaceCheck(modifier, lpad, rpad) abort
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

    return s:Block(b:statusline_whitespace_warning, a:modifier, a:lpad, a:rpad)
endfunction

function! statusline#Mode(mode, lpad, rpad) abort
    let [l:color, l:text] = get(s:modes, a:mode, ['%1*', 'normal'])
    return s:Block(l:text, l:color, a:lpad, a:rpad)
endfunction

function! statusline#File(modifier, lpad) abort
    if &buftype != ''
        let l:file = expand('%:t')
    else
        let l:file = s:ShortFilePath(expand('%'))
    endif

    return s:Block(s:FileIcon() . l:file, a:modifier, a:lpad)
endfunction

function! statusline#Flags(modifier, lpad) abort
    let l:flags = []
    if (&modifiable && &modified)
        call add(l:flags, '+')
    endif

    if &readonly
        call add(l:flags, 'RO')
    endif

    return s:Block(join(l:flags), a:modifier, a:lpad)
endfunction

function! statusline#GitBranch(modifier, lpad) abort
    if !get(g:, 'statusline_git', 1) || !exists('g:loaded_fugitive')
        return ''
    endif

    let l:pad_left = repeat(' ', a:lpad)
    let l:branch = s:Block(fugitive#head(), a:modifier)

    if strlen(l:branch)
        return l:pad_left . '[' . l:branch . ']'
    else
        return ''
    endif
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

    let l:whitespace = s:WhitespaceCheck('%7*', 1, 1)
    if strlen(l:whitespace)
        call add(l:status, l:whitespace)
    endif

    " Neovim LSP diagnostics indicator
    if has('nvim-0.5')
        let l:warnings = luaeval('vim.lsp.diagnostic.get_count(0, [[Warning]])')
        if l:warnings > 0
            call add(l:status, s:Block('warning [' . l:warnings . ']', '%8*', 0))
        endif

        let l:errors = luaeval('vim.lsp.diagnostic.get_count(0, [[Error]])')
        if l:errors > 0
            call add(l:status, s:Block('error [' . l:errors . ']', '%9*', 1, 1))
        endif
    endif

    return join(l:status, ' | ')
endfunction

function! statusline#ActiveStatusLine() abort
    let l:statusline = "%{%statusline#Mode(mode(), 1, 1)%}"
    let l:statusline .= "%{%statusline#File('%<', 1)%}"
    let l:statusline .= "%{%statusline#Flags('%5*', 1)%}"
    let l:statusline .= "%{%statusline#GitBranch('%6*', 1)%}"
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
    let l:statusline = "%{%statusline#File('%<', 1)%}"
    let l:statusline .= "%{%statusline#Flags('', 1)%}"
    let l:statusline .= '%=%l:%c | %{statusline#FileSize()} | %p%% '

    return l:statusline
endfunction

function! statusline#ShortCurrentPath() abort
    return pathshorten(fnamemodify(getcwd(), ':~:.'))
endfunction

function! statusline#NoFileStatusLine() abort
    return '%{statusline#ShortCurrentPath()}'
endfunction

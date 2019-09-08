function! tiago#functions#preserve_cursor(command)
    " preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " do the business:
    execute a:command
    " clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

function! tiago#functions#python_docstring_text_object(inner)
    " TEXT OBJECT FOR IN/AROUND PYTHON DOCSTRING
    "
    " For docstrings in this format:
    " ,------------------------------.
    " | '''                          |
    " | Module-level docstring.      |
    " | Text object works on these.  |
    " | '''                          |
    " |                              |
    " | class Widget():              |
    " | '''                          |
    " | Text object also works       |
    " | on class-level docstrings.   |
    " | '''                          |
    " |                              |
    " |     def __init__(self):      |
    " |         '''                  |
    " |         Method-level, too!   |
    " |         '''                  |
    " |         pass                 |
    " |                              |
    " '------------------------------'
    " Text objects search up, but won't cross def/class lines.
    "
    " get current line number
    let current = line('.')

    let num_quotes = 0
    " climb up to class/def line, or first line of buffer
    while current > 0 && getline(current) !~# '^\s*\(class\|def\)\s*.*:$'
        if getline(current) =~# "[ru]\\?\\('''\\|\"\"\"\\)"
            " found a triple-quotation
            let num_quotes = num_quotes + 1
        endif
        let current = current - 1
    endwhile

    return num_quotes % 2
endfunction

function! tiago#functions#adjust_comment_textwidth()
    if &textwidth == 0
        return
    end

    if !exists('s:n_tw')
        let s:n_tw = &textwidth
    endif

    if !exists('s:n_fopt')
        let s:n_fopt = &formatoptions
    endif

    if !exists('b:c_textwidth')
        if !exists('g:c_textwidth')
            return
        end
        let l:c_tw = g:c_textwidth
    else
        let l:c_tw = b:c_textwidth
    endif

    if !exists('b:c_formatoptions')
        if !exists('g:c_formatoptions')
            return
        end
        let l:c_fopt = g:c_formatoptions
    else
        let l:c_fopt = b:c_formatoptions
    endif

    let cur_syntax = synIDattr(synIDtrans(synID(line("."), col("."), 0)), "name")

    let l:cur_in_docstr = tiago#functions#python_docstring_text_object(1)

    if !exists('s:in_docstr') || l:cur_in_docstr != s:in_docstr
        let s:in_docstr = l:cur_in_docstr

        if l:cur_in_docstr == 1
            execute "setlocal textwidth=" . l:c_tw
            execute "setlocal formatoptions=" . l:c_fopt
        else
            execute "setlocal textwidth=" . s:n_tw
            execute "setlocal formatoptions=" . s:n_fopt
        endif
    endif
endfunction

function! tiago#functions#mutt_setup()
    execute "1,/^$/-1fold"
    execute "normal }"

    let lnum = line(".")

    if lnum == line('$') || getline(lnum + 2) =~ '-- $'
        put! =\"\n\"
        execute "+1"
    elseif getline(lnum + 1) =~ '-\+\s\+Forwarded message' || getline(lnum + 2) =~ '>'
        put! =\"\n\n\"
    else
        execute "+1"
    endif
endfunction

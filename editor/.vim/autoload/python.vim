function! python#docstring_text_object(inner)
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

function! python#adjust_comment_textwidth()
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

    let l:cur_in_docstr = python#docstring_text_object(1)

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

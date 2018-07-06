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

    if cur_syntax == "Comment"
        execute "setlocal textwidth=" . l:c_tw
        execute "setlocal formatoptions=" . l:c_fopt
    elseif cur_syntax == "String"
        " Check to see if we're in a docstring
        let lnum = line(".")

        while lnum >= 1 && (synIDattr(synIDtrans(synID(lnum, col([lnum, "$"]) - 1, 0)), "name") == "String" || match(getline(lnum), '\v^\s*$') > -1)
            if match(getline(lnum), "\\('''\\|\"\"\"\\)") > -1
                " Assume that any longstring is a docstring
                execute "setlocal textwidth=" . l:c_tw
                execute "setlocal formatoptions=" . l:c_fopt
            endif

            let lnum -= 1
        endwhile
    else
        execute "setlocal textwidth=" . s:n_tw
        execute "setlocal formatoptions=" . s:n_fopt
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

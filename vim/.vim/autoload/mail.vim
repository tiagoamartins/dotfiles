function! mail#setup_mutt()
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

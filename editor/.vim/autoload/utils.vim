function utils#get_var(variable)
    " {{{
    if exists('b:' . a:variable)
        let value = eval('b:' . a:variable)
    elseif exists('g:' . a:variable)
        let value = eval('g:' . a:variable)
    else
        let value = ''
    endif
    if a:variable =~ '_lst'
        return split(value, ',')
    else
        return value
    endif
endfunction

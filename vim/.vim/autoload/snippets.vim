" snippets.vim - Global helpers for snippets

if exists('g:autoloaded_snippets') || &cp
    finish
endif
let g:autoloaded_snippets = 1

function! s:try_insert(skel)
    " Expand snippet
    execute "normal! i_" . a:skel . "\<C-r>=UltiSnips#ExpandSnippet()\<CR>"

    " Check if the snippet got expanded
    " if not undo ant change.
    if g:ulti_expand_res == 0
        silent! undo
    endif

    return g:ulti_expand_res
endfunction

function! snippets#InsertSkeleton() abort
    let filename = expand('%')

    " Abort on non-empty buffer or extant file.
    if !(line('$') == 1 && getline('$') == '') || filereadable(filename)
        return
    endif

    if !empty('b:projectionist')
        " Loop through projections with 'skeleton' key and
        " try each one until the snippet expands.
        for [root, value] in projectionist#query('skeleton')
            if s:try_insert(value)
                return
            endif
        endfor
    endif

    " Try generic _skel template as last resort
    call s:try_insert('skel')
endfunction

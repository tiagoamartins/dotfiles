function! window#mark_swap()
    let g:markedWinNum = winnr()
endfunction

function! window#do_swap()
    " mark destination
    let curNum = winnr()
    let curBuf = bufnr( "%" )
    exe g:markedWinNum . "wincmd w"
    " switch to source and shuffle dest->source
    let markedBuf = bufnr( "%" )
    " hide and open so that we aren't prompted and keep history
    exe 'hide buf' curBuf
    " switch to dest and shuffle source->dest
    exe curNum . "wincmd w"
    " hide and open so that we aren't prompted and keep history
    exe 'hide buf' markedBuf
endfunction

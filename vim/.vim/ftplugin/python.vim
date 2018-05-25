setlocal formatoptions-=t
setlocal foldmethod=manual
setlocal textwidth=79

let b:comment_textwidth=72
let b:comment_formatoptions='t' . &formatoptions

if has('autocmd')
    autocmd CursorMoved,CursorMovedI *
                \ call tiago#functions#adjust_comment_textwidth()
endif

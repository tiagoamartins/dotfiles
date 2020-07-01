setlocal formatoptions-=t
setlocal foldmethod=manual
setlocal textwidth=79

let b:c_textwidth=72
let b:c_formatoptions='t' . &formatoptions

if has('autocmd')
    autocmd CursorMoved,CursorMovedI *
                \ call python#adjust_comment_textwidth()
endif

if exists(':BracelessEnable')
    BracelessEnable +indent +fold +hightlight
endif

let g:python_highlight_all = 1

" See also: after/ftplugin/mail.vim

setlocal foldmethod=manual
setlocal wrap

if has('spell')
    setlocal spell
endif

if has('autocmd')
    augroup mutt_composing
        autocmd!
        autocmd BufEnter /tmp/mutt-* call tiago#functions#mutt_setup()
    augroup END
endif

if has('packages')
    if !has('nvim')
        packadd! matchit
    endif
else
    if !has('nvim')
        source $VIMRUNTIME/macros/matchit.vim
    endif
endif

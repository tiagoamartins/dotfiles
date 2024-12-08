" If you use long lines, mutt will automatically switch to quoted-printable
" encoding. This will generally look better in most places that matter (eg.
" Gmail), where hard-wrapped email looks terrible and format=flowed is not
" supported.
setlocal textwidth=0
setlocal foldmethod=manual
setlocal wrap

if has('spell')
    setlocal spell
endif

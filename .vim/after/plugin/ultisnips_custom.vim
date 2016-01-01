" ultisnips_custom.vim - Custom UltiSnips settings

if !exists('did_plugin_ultisnips')
    finish
endif

augroup ultisnips_custom
    autocmd!
    autocmd User ProjectionistActivate silent! call snippet#InsertSkeleton()
    autocmd BufNewFile * silent! call snippet#InsertSkeleton()
augroup END

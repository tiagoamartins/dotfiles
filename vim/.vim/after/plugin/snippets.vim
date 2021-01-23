" Change snippets default directory.
let g:UltiSnipsSnippetDirectories = [expand($VIM_HOME . '/snips')]

" Trigger configuration
let g:UltiSnipsExpandTrigger = '<tab>'

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit = 'vertical'

" Automatic insert skeletons.
augroup SnippetsSkeleton
    autocmd!
    autocmd User ProjectionistActivate silent! call snippets#InsertSkeleton()
    autocmd BufNewFile * silent! call snippets#InsertSkeleton()
augroup END

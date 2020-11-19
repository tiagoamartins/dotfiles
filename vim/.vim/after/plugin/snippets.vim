" Change snippets default directory.
let g:UltiSnipsSnippetDirectories = ["snips"]


" Automatic insert skeletons.
augroup SnippetsSkeleton
    autocmd!
    autocmd User ProjectionistActivate silent! call snippets#InsertSkeleton()
    autocmd BufNewFile * silent! call snippets#InsertSkeleton()
augroup END

setlocal commentstring=--\ %s

nnoremap <buffer> <leader>a= :Tabularize /^[^<=]*\zs<=<CR>
vnoremap <buffer> <leader>a= :Tabularize /^[^<=]*\zs<=<CR>
nnoremap <buffer> <leader>a: :Tabularize /^[^:]*\zs:<CR>
vnoremap <buffer> <leader>a: :Tabularize /^[^:]*\zs:<CR>

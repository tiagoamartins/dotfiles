" Leader {{{1
" -----------
" Toggle value (using switch plugin)
nnoremap <leader>gt :Switch<cr>
nnoremap <silent> <leader>wm :call window#mark_swap()<CR>
nnoremap <silent> <leader>wp :call window#do_swap()<CR>
" Turn off search highlight
nnoremap <leader><leader> :nohlsearch<cr>
" Remove trailing space
nnoremap <leader>$ :call cursor#preserve("%s/\\s\\+$//e")<cr>
" Indent entire file
nnoremap <leader>= :call cursor#preserve("normal gg=G")<cr>
" Edit vimrc
nnoremap <leader>ev :vsp $MYVIMRC<cr>
" Load vimrc
nnoremap <leader>sv :source $MYVIMRC<cr>
" Change spelling language
if exists("+spelllang")
    nnoremap <silent> <leader>en :set spelllang=en_us<cr>
    nnoremap <silent> <leader>pt :set spelllang=pt_br<cr>
endif
" Replace without loosing current yank
vnoremap <leader>p "_dp
vnoremap <leader>P "_dP

" Tests {{{2
nmap <silent> <leader>tn :TestNearest<cr>
nmap <silent> <leader>tf :TestFile<cr>
nmap <silent> <leader>ts :TestSuite<cr>
nmap <silent> <leader>tl :TestLast<cr>
nmap <silent> <leader>tv :TestVisit<cr>

" Tabularize {{{2
nnoremap <buffer> <leader>a= :Tabularize /^[^<=]*\zs<=<cr>
vnoremap <buffer> <leader>a= :Tabularize /^[^<=]*\zs<=<cr>
nnoremap <buffer> <leader>a: :Tabularize /^[^:]*\zs:<cr>
vnoremap <buffer> <leader>a: :Tabularize /^[^:]*\zs:<cr>

" Function keys {{{1
" ------------------
" Toggle spelling
noremap <f4> :set spell!<cr> <bar> :echo "spell check: " . strpart("offon", 3 * &spell, 3)<cr>

nnoremap <f9> :Dispatch<cr>
nnoremap <f10> :Mbuild<cr>

" Normal mode {{{1
" ----------------
" Set space to toggle a fold
nnoremap <space> za
" Swap two characters with capability of repeat by '.' (using repeat plugin)
nnoremap <silent> <plug>TransposeCharacters xp2h :call repeat#set("\<plug>TransposeCharacters")<cr>
nmap cp <plug>TransposeCharacters
" Highlight last inserted text
nnoremap gV `[v`]

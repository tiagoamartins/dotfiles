" Leader {{{1
" -----------
" Toggle value (using switch plugin)
nnoremap <leader>gt :Switch<cr>
" Turn off search highlight
nnoremap <leader><space> :nohlsearch<cr>
" Remove trailing space
nnoremap <leader>$ :call cursor#preserve("%s/\\s\\+$//e")<cr>
" Indent entire file
nnoremap <leader>= :call cursor#preserve("normal gg=G")<cr>
" Edit vimrc
nnoremap <leader>ev :vsp $MYVIMRC<cr>
" Load vimrc
nnoremap <leader>sv :source $MYVIMRC <bar> AirlineRefresh<cr>
" Change spelling language
if exists("+spelllang")
    nnoremap <silent> <leader>en :set spelllang=en_us<cr>
    nnoremap <silent> <leader>pt :set spelllang=pt_br<cr>
endif
" Replace without loosing current yank
vnoremap <leader>p "_dp
vnoremap <leader>P "_dP

" Function keys {{{1
" ------------------
" Toggle spelling with F4 key
noremap <f4> :set spell!<cr> <bar> :echo "spell check: " . strpart("offon", 3 * &spell, 3)<cr>
" Run continue (using termdebug plugin)
nnoremap <f5> :Continue<cr>
" Run make (using dispatch plugin)
nnoremap <f8> :Make<cr>
" Run dispatch (using dispatch plugin)
nnoremap <f9> :Dispatch<cr>
" Run over (using termdebug plugin)
nnoremap <f10> :Over<cr>
" Run step (using termdebug plugin)
nnoremap <f11> :Step<cr>

" Normal mode {{{1
" ----------------
" Set space to toggle a fold
nnoremap <space> za
" Swap two characters with capability of repeat by '.' (using repeat plugin)
nnoremap <silent> <plug>TransposeCharacters xp2h :call repeat#set("\<plug>TransposeCharacters")<cr>
nmap cp <plug>TransposeCharacters
" Highlight last inserted text
nnoremap gV `[v`]

" ---------- Searching ----------
" Turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>

" ---------- Indentation ----------
"Shortcut to auto indent entire file
nmap <leader>$ :call cursor#preserve("%s/\\s\\+$//e")<CR>
nmap <leader>= :call cursor#preserve("normal gg=G")<CR>

" ---------- Folding ----------
" Set space to toggle a fold
nnoremap <space> za

" ---------- Movement ----------
" Highlight last inserted text
nnoremap gV `[v`]

" ---------- Leader Shortcuts ----------
" Edit vimrc/bashrc and load vimrc bindings
nnoremap <leader>ev :vsp $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC <BAR> AirlineRefresh<CR>

" Toggle spelling with F4 key
map <F4> :set spell!<CR><Bar>:echo "Spell Check: " . strpart("OffOn", 3 * &spell, 3)<CR>

" ---------- Spelling ----------
if exists("+spelllang")
    " Change spelling language
    nmap <silent> <leader>pt :set spelllang=pt_br<CR>
    nmap <silent> <leader>en :set spelllang=en_us<CR>
endif

" ---------- Mappings ----------
nnoremap <silent> <Plug>TransposeCharacters xp2h :call repeat#set("\<Plug>TransposeCharacters")<CR>
nmap cp <Plug>TransposeCharacters
nnoremap <F8> :Make<CR>
nnoremap <F9> :Dispatch<CR>
nnoremap <leader>t :Switch<CR>

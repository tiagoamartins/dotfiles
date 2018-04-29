let g:airline_theme = "hybridline"
let g:airline_powerline_fonts = 1   " Enable use of powerline fonts

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_symbols.maxlinenr='≡'
let g:airline_symbols.crypt = 'œ'
let g:airline_symbols.notexists = '∅'
let g:airline_symbols.whitespace = 'Ξ'

let g:airline#extensions#branch#enabled = 1

let g:airline#extensions#tabline#enabled = 1        " Enable the list of buffers
let g:airline#extensions#tabline#fnamemod = ":t"    " Show just the filename
let g:airline#extensions#tabline#tab_nr_type = 2    " Show splits and tab numbers

let g:airline#extensions#whitespace#enabled = 1
let g:airline#extensions#whitespace#mixed_indent_algo = 1

let g:airline#extensions#ale#enabled = 1

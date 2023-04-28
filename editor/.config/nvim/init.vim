" disable python 2 support
let g:loaded_python_provider = 0

" load default python 3
if exists("$VIRTUAL_ENV")
    let g:python3_host_prog=substitute(system("which -a python3 | head -n2 | tail -n1"), "\n", '', 'g')
else
    let g:python3_host_prog=substitute(system("which python3"), "\n", '', 'g')
endif

" disable ruby support
let g:loaded_ruby_provider = 0

" disable node js support
let g:loaded_node_provider = 0

" disable perl support
let g:loaded_perl_provider = 0

" load vim's config
source ~/.vimrc

lua require('config.lazy')

" Color schemes {{{1
" ------------------
try
    let g:hybrid_custom_term_colors = 1
    set background=dark
    colorscheme hybrid          " Set color scheme

    if has('termguicolors') && &term !~ ".*rxvt.*"
        set termguicolors       " Use guifg/guibg instead of ctermfg/ctermbg in terminal
    endif
catch
    colorscheme default
endtry
" }}}1

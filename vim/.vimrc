let mapleader = '\'             " Leader is backslash

filetype on                     " Enable file type detection
filetype plugin on              " Enable plugins to detect file types
filetype indent on              " Indent depends on filetype

syntax on                       " Enable syntax processing

" Prefer python 3 over python 2
if has('pythonx')
    if has('python3')
        set pyxversion=3
    elseif has('python')
        set pyxversion=2
    endif
endif

if &loadplugins && !has('packages')
    if has("vim_starting")
        runtime! pack/vendor/opt/pathogen/autoload/pathogen.vim
    endif

    execute pathogen#infect()
endif

try
    let g:hybrid_custom_term_colors = 1
    colorscheme hybrid          " Set color scheme

    if has('termguicolors') && &term !~ ".*rxvt.*"
        set termguicolors       " Use guifg/guibg instead of ctermfg/ctermbg in terminal
    endif
catch
    colorscheme peachpuff
endtry
set background=dark             " Set a dark background profile

" Change drop-down menu color
highlight PmenuSel ctermfg=black ctermbg=lightgray

if filereadable(glob($MYVIMRC . ".local"))
    source $MYVIMRC.local
endif

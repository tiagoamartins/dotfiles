let mapleader = '\'             " Leader is backslash

filetype on                     " Enable file type detection
filetype plugin on              " Enable plugins to detect file types
filetype indent on              " Indent depends on filetype

syntax on                       " Enable syntax processing

set background=dark             " Set a dark background profile
try
    let g:hybrid_custom_term_colors = 1
    colorscheme hybrid          " Set color scheme
catch
    colorscheme peachpuff
endtry

" Change drop-down menu color
highlight PmenuSel ctermfg=black ctermbg=lightgray

if filereadable(glob($MYVIMRC . ".local"))
    source $MYVIMRC.local
endif

if &loadplugins && !has('packages')
    if has("vim_starting")
        runtime! pack/vendor/opt/pathogen/autoload/pathogen.vim
    endif

    execute pathogen#infect()
endif

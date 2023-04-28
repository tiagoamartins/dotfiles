let mapleader = '\'             " Leader is backslash

if has('autocmd')
    filetype on                 " Enable file type detection
    filetype plugin on          " Enable plugins to detect file types
    filetype indent on          " Indent depends on filetype
endif

if has('syntax') && !exists('g:syntax_on')
    syntax enable               " Enable syntax processing
endif

" Prefer python 3 over python 2
if has('pythonx')
    if has('python3')
        set pyxversion=3
    elseif has('python')
        set pyxversion=2
    endif
endif

" Home Directory {{{1
" -------------------
" Get the vim files directory
" In Windows/Linux, take in a difference of '.vim' and 'vimfiles'
if has("win32") || has ("win64")
    let $VIM_HOME = expand("$HOME/vimfiles")
else
    let $VIM_HOME = expand("$HOME/.vim")
endif

if has('nvim')
    let $VIM_TEMP = expand($HOME . '/.cache/nvim/temp')
else
    let $VIM_TEMP = expand($VIM_HOME . '/temp')
endif

if filereadable(glob($MYVIMRC . ".local"))
    source $MYVIMRC.local
endif

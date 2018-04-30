" General {{{1
" ------------
set nocompatible                " Be IMproved
set mouse=a                     " Allow mouse use for all modes
set hidden                      " Allow you to hide buffers with unsaved changes without being prompted
set encoding=utf-8
set fileencodings=utf-8

" Home Directory {{{1
" -------------------
" Get the vim files directory
" In Windows/Linux, take in a difference of '.vim' and 'vimfiles'
if has("win32") || has ("win64")
    let $VIM_HOME = expand("$HOME/vimfiles")
else
    let $VIM_HOME = expand("$HOME/.vim")
endif

" Backup & Swap {{{1
" ------------
if exists('$SUDO_USER')         " Don't create root-owned files
    set nobackup
    set nowritebackup
else
    let s:backup_dir = expand($VIM_HOME . '/temp/backup')
    if exists('*mkdir') && !isdirectory(s:backup_dir)
        call mkdir(s:backup_dir, 'p')
    endif
    set backupdir=$VIM_HOME/temp/backup
    set backup                  " Keep backup after closing the file
    set writebackup             " Create backup file after overwriting the file
endif

" Don't backup files in temp directories or shm
if has('wildignore')
    if &backupskip !~ '/tmp/\*'
        set backupskip+=/tmp/*  " Make sure temp files have no backup (security reason)
    endif
    set backupskip+=*/shm/*
endif

if exists('&swapsync')
    set swapsync=               " Let OS sync swapfiles lazily
endif

if exists('$SUDO_USER')         " Don't create root-owned files
    set noswapfile
else
    let s:swap_dir = expand($VIM_HOME . '/temp/swap')
    if exists('*mkdir') && !isdirectory(s:swap_dir)
        call mkdir(s:swap_dir, 'p')
    endif
    set directory=$VIM_HOME/temp/swap//
    set swapfile
endif

" History {{{1
" ------------
if has('cmdline_hist')
    set history=100
endif

if has('viminfo')
    if exists('$SUDO_USER')     " Don't create root-owned files
        set viminfo=
    else
        set viminfo+=n$VIM_HOME/temp/viminfo

        if !empty(glob($VIM_HOME . '/temp/viminfo'))
            if !filereadable(expand($VIM_HOME . '/temp/viminfo'))
                echoerr expand('warning: ' . $VIM_HOME .
                              \'/temp/viminfo exists but is not readable')
            endif
        endif
    endif
endif

" Persist undo tree between sessions
if has('persistent_undo')
    if exists('$SUDO_USER')     " Don't create root-owned files
        set noundofile
    else
        let s:undo_dir = $VIM_HOME . '/temp/undo'
        if exists('*mkdir') && !isdirectory(s:undo_dir)
            call mkdir(s:undo_dir, "p")
        endif
        set undodir=$VIM_HOME/temp/undo
        set undofile            " Actually use undo files
        set undolevels=100
    endif
endif

if has('mksession')
    let s:view_dir = $VIM_HOME . '/temp/view'
    if exists('*mkdir') && !isdirectory(s:view_dir)
        call mkdir(s:view_dir, "p")
    endif
    set viewdir=$VIM_HOME/temp/view
    set viewoptions=cursor,folds    " Save/restore just these (with `:{mk,load}view`)
endif

" UI Configuration {{{1
" ---------------------
set number                      " Enable line numbering, taking up 6 spaces
if exists('+relativenumber')
    set relativenumber          " Enable relative line numbering, with the number option set it goes to hybrid mode (Vim 7.4+)
endif
set cursorline                  " Highlight the current line
set lazyredraw                  " Redraw only when it needs to
set showmatch                   " Highlight matching {[()]}
set nowrap                      " Turn off line wrapping
set laststatus=2                " Always show status line
set scrolloff=3                 " Have a number of offset lines (or buffer) when scrolling
set sidescrolloff=3             " Same as 'scrolloff', but for columns
if has('linebreak')
    set linebreak               " Wrap long lines at characters in 'breakat'
    let &showbreak='⤷ '         " Arrow pointing downwards then curving rightwards (U+2937, UTF-8: E2 A4 'B7)
endif

if has('syntax')
    set colorcolumn=+1          " Show column line 1 char after 'textwidth'
endif

if has('cmdline_info')
    set noshowcmd               " Don't show extra info at end (right) of command line
endif

if has('wildmenu')
    set wildmenu                " Visual autocomplete for command menu
endif
if has('wildignore')
    set wildignore+=*.o,*.rej   " Patterns to ignore during file-navigation
endif
set wildmode=longest:full,full  " Shell-like autocomplete to unambiguous portion

" Symbols for visualization of special characters
set listchars=eol:¶             " Pilcrow sign (U+00B6, UTF-8: C2 B6)
set listchars+=tab:→\           " Rightwards arrow (U+2192, UTF-8: E2 86 92) followed by space (has to be escaped with '\')
set listchars+=extends:»        " Right-pointing double angle quotation mark (U+00BB, UTF-8: C2 BB)
set listchars+=precedes:«       " Left-pointing double angle quotation mark (U+00AB, UTF-8: C2 AB)
set listchars+=trail:•          " Bullet (U+2022, UTF-8: E2 80 A2)
set listchars+=nbsp:○           " White circle (U+25CB, UTF-8: E2 97 8B)
if v:version > 704 || v:version == 704 && has("patch710")
    set listchars+=space:∙      " Bullet operator (U+2219, UTF-8: E2 88 99)
endif

set shortmess+=A                " Ignore annoying swapfile messages
set shortmess+=I                " No splash screen
set shortmess+=O                " File-read message overwrites previous
set shortmess+=T                " Truncate non-file messages in middle
set shortmess+=W                " Don't echo '[w]'/'[written]' when writing
set shortmess+=a                " Use abbreviations in messages eg. '[RO]' instead of '[readonly]'
set shortmess+=o                " Overwrite file-written messages
set shortmess+=t                " Truncate file messages at start

" Spacing {{{1
" ------------
set tabstop=8                   " Set tab character visually to a number of spaces characters
set softtabstop=0               " Number of spaces in tab when editing
set shiftwidth=8                " Indent width for autoindent
set noexpandtab                 " Turn tabs into whitespace
set backspace=indent,eol,start  " Set backspace to be able to delete previous characters
set textwidth=0                 " Width necessary to auto split lines

" Fonts {{{1
" ----------
if has("gui_running")
    if has("gui_win32")
        " On Vim 7.4.16 the following line still doesn't work with gui_gtk
        set guifont=Consolas:h10:cDEFAULT,Inconsolata:h10,Courier\ New:h10

    elseif has("gui_mac") || has("gui_macvim")
        set guifont=Menlo\ Regular:h11

    else "gui_gtk
        let terminess = system("fc-list | grep -c \"Terminess Powerline\"")
        let terminus = system("fc-list | grep -c Terminus")

        if (terminess > 0)
            set guifont=Terminess\ Powerline\ 12
        elseif (terminus > 0)
            set guifont=Terminus\ 12
        else
            set guifont=Monospace\ 11
        endif
    endif
endif

" Searching {{{1
" --------------
set incsearch                   " Search as characters are entered
set hlsearch                    " Highlight matches
set ignorecase                  " By default ignore case
set smartcase                   " Unless upper case is explicit
set matchtime=2                 " Tenths of a second to show the matching pattern

" Formatting {{{1
" ----------------
set smartindent                 " Turn on smart indent
set fileformats=unix,dos,mac

set formatoptions+=n            " Smart auto-indenting inside numbered lists
if v:version > 703 || v:version == 703 && has('patch541')
    set formatoptions+=j        " Remove comment leader when joining comment lines
endif

" Folding {{{1
" ------------
if has('folding')
    if has('windows')
        set fillchars=vert:┃    " Box drawings heavy vertical (U+2503, UTF-8: E2 94 83)
        set fillchars+=fold:·   " Middle dot (U+00B7, UTF-8: C2 B7)
    endif

    set foldenable              " Enable folding
    set foldmethod=marker       " Enable indent folding
    set foldlevelstart=99       " Start unfolded
endif

" Windowing {{{1
" --------------
set splitbelow                  " New splits appear below for horizontal splits
set splitright                  " New splits appear at right for vertical splits
set bufhidden=hide              " Hide buffer when not in window (to prevent relogin with FTP edit)

" Status Line {{{1
" ----------------
set laststatus=2                " Always have a status line

" Spelling {{{1
" -------------
if has("spell")
    " Turn spelling off by default
    set nospell

    " Limit it to just the top 10 items
    set spellsuggest=best,10

    " Word completion
    set complete+=kspell
endif

if exists("+spelllang")
    set spelllang=en_us
endif

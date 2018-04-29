" General {{{1
" ------------
if &compatible
    set nocompatible            " Be iMproved
endif

set encoding=utf-8
set fileencodings=utf-8

set fileformats=unix,dos,mac

" Use 256 colors terminal
set t_Co=256

" Make sure Pathogen works with Vim Sessions
set sessionoptions-=options

" Mouse {{{1
" ----------
set mouse=a                     " Allow mouse use for all modes

" Home Directory {{{1
" -------------------
" Get the vim files directory
" In Windows/Linux, take in a difference of '.vim' and 'vimfiles'
if has("win32") || has ("win64")
    let $VIM_HOME = expand("$HOME/vimfiles")
else
    let $VIM_HOME = expand("$HOME/.vim")
endif

" Backups {{{1
" ------------
if exists('*mkdir')
    " Backup directories
    " Persist (g)undo tree between sessions
    if has("persistent_undo")
        if !isdirectory($VIM_HOME . "/temp/undo")
            call mkdir($VIM_HOME . "/temp/undo", "p")
        endif
        set undodir=$VIM_HOME/temp/undo//
        set undofile
        set undolevels=100
    endif

    if !isdirectory($VIM_HOME . "/temp/backup")
        call mkdir($VIM_HOME . "/temp/backup", "p")
    endif
    set backupdir=$VIM_HOME/temp/backup//
    set backup                  " Keeps a backup after closing the file
    set writebackup             " Creates a backup file after overwriting the file
    set directory=              " Avoid creating swap folder
    set noswapfile              " Swap files are a nuisance
endif

set history=100

if has('viminfo')
    set viminfo+=n$VIM_HOME/temp/viminfo
endif

" Don't backup files in temp directories or shm
if exists('&backupskip')
    set backupskip+=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*
endif

" UI Configuration {{{1
" ---------------------
set number                      " Enable line numbering, taking up 6 spaces
set relativenumber              " Enable relative line numbering, with the number option set it goes to hybrid mode (Vim 7.4+)
set cursorline                  " Highlight the current line
set wildmenu                    " Visual autocomplete for command menu
set lazyredraw                  " Redraw only when it needs to
set showmatch                   " Highlight matching {[()]}
set nowrap                      " Turn off line wrapping
set scrolloff=3                 " Have a number of offset lines (or buffer) when scrolling

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

" Indentation {{{1
" ----------------
set smartindent                 " Turn on smart indent

" Folding {{{1
" ------------
set foldenable                  " Enable folding
set foldlevelstart=10           " Open most folds by default
set foldnestmax=10              " Maximum of 10 nested folds

set foldmethod=marker           " Enable indent folding

" Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:→\ ,eol:¶,trail:␣,extends:»,precedes:«,nbsp:+
if has("patch-7.4.710")
    set listchars+=space:∙
endif

" Buffers {{{1
" ------------
" This allows buffers to be hidden if you've modified a buffer.
" This is almost a must if you wish to use buffers in this way.
set hidden

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

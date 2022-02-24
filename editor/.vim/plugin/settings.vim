" General {{{1
" ------------
set nocompatible                " Be IMproved
set mouse=a                     " Allow mouse use for all modes
set hidden                      " Allow you to hide buffers with unsaved changes without being prompted
set encoding=utf-8
set fileencodings=utf-8

" Backup & Swap {{{1
" ------------------
if exists('$SUDO_USER')         " Don't create root-owned files
    set nobackup
    set nowritebackup
else
    let s:backupdir = expand($VIM_TEMP . '/backup')
    if exists('*mkdir') && !isdirectory(s:backupdir)
        call mkdir(s:backupdir, 'p')
    endif
    let &backupdir = s:backupdir
    set backup                  " Keep backup after closing the file
    set writebackup             " Create backup file after overwriting the file
endif

" Don't backup files in temp or shared memory directories
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
    let s:swapdir = expand($VIM_TEMP . '/swap')
    if exists('*mkdir') && !isdirectory(s:swapdir)
        call mkdir(s:swapdir, 'p')
    endif
    let &directory = s:swapdir . '//'
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
        let s:viminfo = expand($VIM_TEMP . '/viminfo')
        let &viminfo .= ',n' . s:viminfo

        if !empty(glob(s:viminfo))
            if !filereadable(s:viminfo)
                echoerr expand('warning: ' . $VIM_TEMP .
                            \'/viminfo exists but is not readable')
            endif
        endif
    endif
endif

" Persist undo tree between sessions
if has('persistent_undo')
    if exists('$SUDO_USER')     " Don't create root-owned files
        set noundofile
    else
        let s:undodir = expand($VIM_TEMP . '/undo')
        if exists('*mkdir') && !isdirectory(s:undodir)
            call mkdir(s:undodir, "p")
        endif
        let &undodir = s:undodir
        set undofile            " Actually use undo files
        set undolevels=100
    endif
endif

if has('mksession')
    let s:viewdir = expand($VIM_TEMP . '/view')
    if exists('*mkdir') && !isdirectory(s:viewdir)
        call mkdir(s:viewdir, "p")
    endif
    let &viewdir = s:viewdir
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
set noshowmode                  " Remove mode change message
set laststatus=2                " Always show status line
set scrolloff=3                 " Have a number of offset lines (or buffer) when scrolling
set sidescrolloff=3             " Same as 'scrolloff', but for columns
if has('linebreak')
    set linebreak               " Wrap long lines at characters in 'breakat'
    let &showbreak='∟ '         " Right angle (U+221F, UTF-8: E2 88 9F)
endif

if has('syntax')
    set colorcolumn=+1          " Show column line 1 char after 'textwidth'
endif

if has('cmdline_info')
    set noshowcmd               " Don't show extra info at end (right) of command line
endif

set completeopt=menu            " Show menu when completing more than one option
set completeopt+=preview        " Show extra information about the selected completion
if v:version > 704 || v:version == 704 && has("patch775")
    set completeopt+=noinsert       " Do not auto-insert any text
    set completeopt+=noselect       " Do not auto-select a match in the menu
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
set noexpandtab                 " Don't turn tabs into whitespace
set shiftround                  " Always indent by multiple of shiftwidth
set smarttab                    " <Tab>/<BS> indent/dedent in leading whitespace
set backspace=indent,eol,start  " Set backspace to be able to delete previous characters
set textwidth=0                 " Width necessary to auto split lines

" Searching {{{1
" --------------
set incsearch                   " Search as characters are entered
set hlsearch                    " Highlight matches
set ignorecase                  " By default ignore case
set smartcase                   " Unless upper case is explicit
set matchtime=2                 " Tenths of a second to show the matching pattern

" Formatting {{{1
" ---------------
set smartindent                 " Turn on smart indent
set nojoinspaces                " Don't autoinsert two spaces after '.', '?', '!' for join command
set fileformats=unix,dos,mac

if has('virtualedit')
    set virtualedit=block       " Allow cursor to move where there is no text in visual block mode
endif
set whichwrap=b,h,l,s,<,>,[,],~ " Allow <BS>/h/l/<Space>/<Left>/<Right>/~ to cross line boundaries

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
if has('windows')
    set splitbelow              " New splits appear below for horizontal splits
endif
if has('vertsplit')
    set splitright              " New splits appear at right for vertical splits
endif
set bufhidden=hide              " Hide buffer and not unload when not in window (to prevent relogin with FTP edit)
set switchbuf=usetab            " Try to reuse windows/tabs when switching buffers

" Spelling {{{1
" -------------
if has('syntax')
    set nospell                 " Turn spelling off by default
    set spellsuggest=best,10    " Limit it to just the top 10 items
    set spellcapcheck=          " Don't check for capital letters at start of sentence
    set complete+=kspell        " Word completion
    set spelllang=en_us
endif

" GUI {{{1
" --------
if has("gui_running")
    set guioptions-=m           " Remove menu bar
    set guioptions-=r           " Remove right-hand scroll bar
    set guioptions-=L           " Remove left-hand scroll bar
    set guioptions-=T           " Remove toolbar

    if has("gui_win32")
        " On Vim 7.4.16 the following line still doesn't work with gui_gtk
        set guifont=Consolas:h10:cDEFAULT,Inconsolata:h10,Courier\ New:h10

    elseif has("gui_mac") || has("gui_macvim")
        set guifont=Menlo\ Regular:h11

    else "gui_gtk
        let terminus = system("fc-list | grep -c \"Terminus\"")

        if (terminus > 0)
            set guifont=Terminus\ 12
        else
            set guifont=Monospace\ 11
        endif
    endif
endif

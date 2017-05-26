" ---------- Home Path ----------
" Get the vim files directory
" In Windows/Linux, take in a difference of ".vim" and "$VIM/vimfiles".
if has("win32") || has ("win64")
    let $DOTVIM = expand("$HOME/vimfiles")
else
    let $DOTVIM = expand("$HOME/.vim")
endif

" ---------- Vim Defaults ----------
if &compatible
    set nocompatible            " Be iMproved
endif

set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8

let mapleader = '\'             " Leader is backslash

set fileformats=unix,dos,mac

" Use 256 colors terminal
set t_Co=256

" ---------- Pathogen ----------
let pathogen_readme = expand("$DOTVIM/vendor/pathogen/README.markdown")

if !filereadable(pathogen_readme)
    echo "Installing Pathogen..."
    echo ""
    if !isdirectory($DOTVIM . "/vendor")
        call mkdir($DOTVIM . "/vendor", "p")
    endif
    silent execute "!git clone https://github.com/tpope/vim-pathogen " . $DOTVIM . "/vendor/pathogen"
endif

if has("vim_starting")
    " Required:
    " Set the runtime path to include Pathogen
    runtime! vendor/pathogen/autoload/pathogen.vim
endif

" Required:
" Initialize and pass a path where Pathogen should get plugins
execute pathogen#infect("vendor/{}")
execute pathogen#infect("bundle/{}")
filetype plugin on              " Enable plugins to detect file types

" Make sure Pathogen works with Vim Sessions
set sessionoptions-=options

" ---------- Mouse ----------
set mouse=a                     " Allow mouse use for all modes

" ---------- Backups ----------

if exists('*mkdir')
    " Backup directories
    " Persist (g)undo tree between sessions
    if has("persistent_undo")
        if !isdirectory($DOTVIM . "/temp/undo")
            call mkdir($DOTVIM . "/temp/undo", "p")
        endif
        set undodir=$DOTVIM/temp/undo//
        set undofile
        set undolevels=100
    endif

    if !isdirectory($DOTVIM . "/temp/backup")
        call mkdir($DOTVIM . "/temp/backup", "p")
    endif
    set backupdir=$DOTVIM/temp/backup//
    set backup                  " Keeps a backup after closing the file
    set writebackup             " Creates a backup file after overwriting the file
    set noswapfile              " Swap files are a nuisance
endif

set history=100

if has('viminfo')
    set viminfo='100,n$DOTVIM/temp/viminfo
endif

" Don't backup files in temp directories or shm
if exists('&backupskip')
    set backupskip+=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*
endif

" Don't keep swap files in temp directories or shm
if has('autocmd')
    augroup swapskip
        autocmd!
        silent! autocmd BufNewFile,BufReadPre
                    \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*
                    \ setlocal noswapfile
    augroup END
endif

" Don't keep undo files in temp directories or shm
if has('persistent_undo') && has('autocmd')
    augroup undoskip
        autocmd!
        silent! autocmd BufWritePre
                    \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*
                    \ setlocal noundofile
    augroup END
endif

" Don't keep viminfo for files in temp directories or shm
if has('viminfo')
    if has('autocmd')
        augroup viminfoskip
            autocmd!
            silent! autocmd BufNewFile,BufReadPre
                        \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*
                        \ setlocal viminfo=
        augroup END
    endif
endif

" ---------- Colors ----------
syntax enable                   " Enable syntax processing
set background=dark             " Set a dark background profile
try
    let g:hybrid_custom_term_colors = 1
    colorscheme hybrid              " Set color scheme
catch
    colorscheme peachpuff
endtry

" ---------- UI Configuration ----------
set number                      " Enable line numbering, taking up 6 spaces
set relativenumber              " Enable relative line numbering, with the number option set it goes to hybrid mode (Vim 7.4+)
set cursorline                  " Highlight the current line
set wildmenu                    " Visual autocomplete for command menu
set lazyredraw                  " Redraw only when it needs to
set showmatch                   " Highlight matching {[()]}
set nowrap                      " Turn off line wrapping
set scrolloff=3                 " Have a number of offset lines (or buffer) when scrolling

" ---------- Spacing ----------
set tabstop=8                   " Set tab character visually to a number of spaces characters
set softtabstop=0               " Number of spaces in tab when editing
set shiftwidth=8                " Indent width for autoindent
set noexpandtab                 " Turn tabs into whitespace
set backspace=indent,eol,start  " Set backspace to be able to delete previous characters
set textwidth=0                 " Width necessary to auto split lines

" Only do this part when compiled with support for autocommands
if has("autocmd")
    " Enable file type detection
    filetype on

    " Syntax of these languages is fussy over tabs Vs spaces
    autocmd FileType make setlocal noexpandtab
    autocmd FileType html setlocal noexpandtab
    autocmd FileType yaml setlocal noexpandtab softtabstop=2 shiftwidth=2

    " Add wrap to Markdown files
    autocmd FileType markdown setlocal wrap

    " Treat .rss files as XML
    autocmd BufNewFile,BufRead *.rss setfiletype xml
endif

" ---------- Fonts ----------
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

" ---------- Searching ----------
set incsearch                   " Search as characters are entered
set hlsearch                    " Highlight matches
set ignorecase                  " By default ignore case
set smartcase                   " Unless upper case is explicit
set matchtime=2                 " Tenths of a second to show the matching pattern

" Turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>

" ---------- Indentation ----------
filetype indent on              " Indent depends on filetype
set smartindent                 " Turn on smart indent

"Shortcut to auto indent entire file
nmap <leader>$ :call Preserve("%s/\\s\\+$//e")<CR>
nmap <leader>= :call Preserve("normal gg=G")<CR>

augroup VhdlTabular
    autocmd!
    autocmd FileType vhdl nnoremap <buffer> <leader>a= :Tabularize /^[^<=]*\zs<=<CR>
    autocmd FileType vhdl vnoremap <buffer> <leader>a= :Tabularize /^[^<=]*\zs<=<CR>
    autocmd FileType vhdl nnoremap <buffer> <leader>a: :Tabularize /^[^:]*\zs:<CR>
    autocmd FileType vhdl vnoremap <buffer> <leader>a: :Tabularize /^[^:]*\zs:<CR>
augroup END

" ---------- Folding ----------
set foldenable                  " Enable folding
set foldlevelstart=10           " Open most folds by default
set foldnestmax=10              " Maximum of 10 nested folds

" Set space to toggle a fold
nnoremap <space> za

set foldmethod=marker           " Enable indent folding

" ---------- Movement ----------

" Move vertically by visual line
"nnoremap j gj
"nnoremap k gk

" Highlight last inserted text
nnoremap gV `[v`]

" ---------- Leader Shortcuts ----------

" Edit vimrc/bashrc and load vimrc bindings
nnoremap <leader>ev :vsp $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC <BAR> AirlineRefresh<CR>

" Save session
nnoremap <leader>s :mksession<CR>

" Use the same symbols as TextMate for tabstops and EOLs
set listchars=space:∙,tab:→\ ,eol:¬,trail:-,extends:>,precedes:<,nbsp:+

" ---------- Buffers ----------

" This allows buffers to be hidden if you've modified a buffer.
" This is almost a must if you wish to use buffers in this way.
set hidden

" ---------- Windowing ----------
set splitbelow                  " New splits appear below for horizontal splits
set splitright                  " New splits appear at right for vertical splits
set bufhidden=hide              " Hide buffer when not in window (to prevent relogin with FTP edit)

" ---------- Status Line ----------
set laststatus=2                " Always have a status line

" ---------- Spelling ----------
if has("spell")
    " Turn spelling off by default
    set nospell

    " Toggle spelling with F4 key
    map <F4> :set spell!<CR><Bar>:echo "Spell Check: " . strpart("OffOn", 3 * &spell, 3)<CR>

    " Change menu color
    highlight PmenuSel ctermfg=black ctermbg=lightgray

    " Limit it to just the top 10 items
    set spellsuggest=best,10
endif

" ---------- File Open ----------
" Make sure Vim returns to the same line when you reopen a file.
augroup line_return
    au!
    au BufReadPost *
                \ if line("'\"") > 0 && line("'\"") <= line("$") |
                \     execute 'normal! g`"zvzz' |
                \ endif
augroup END

" ---------- Abbreviations ----------
" no one is really happy until you have this shortcuts
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

" ---------- Airline ----------
let g:airline_theme = "hybridline"
let g:airline_powerline_fonts = 1                   " Disable use of powerline fonts

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

let g:airline#extensions#syntastic#enabled = 1

" ---------- Syntastic ----------
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_error_symbol = 'X'
let g:syntastic_warning_symbol = 'Δ'
let g:syntastic_style_error_symbol = 'X'
let g:syntastic_style_warning_symbol = 'Δ'
let g:syntastic_aggregate_errors = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_python_checkers = ['flake8', 'pyflakes', 'pylint']
let g:syntastic_python_flake8_args = '--max-line-length=90'

let g:syntastic_c_checkers = ['splint', 'gcc']
let g:syntastic_c_splint_args = '-weak'

let g:syntastic_vhdl_checkers = ['ghdl']

autocmd BufRead *.vhd if isdirectory('work') || (exists('b:projectionist') && !empty('b:projectionist')) |
        \ let b:syntastic_checkers = ['vcom', 'ghdl'] |
        \ let b:syntastic_vhdl_vcom_args = '-2008 -work ' . GetSimulationDir() |
        \ let b:syntastic_vhdl_ghdl_args = '--workdir=' . GetSimulationDir() | endif

" ---------- Commentary ----------
autocmd FileType vhdl set commentstring=--\ %s
autocmd FileType verilog set commentstring=\/\/\ %s
autocmd FileType systemverilog set commentstring=\/\/\ %s
autocmd FileType matlab set commentstring=\%\ %s

" ---------- UltiSnips ----------
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<Tab>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" ---------- Functions ----------
function! Preserve(command)
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    execute a:command
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

function! GetSimulationDir() abort
    if exists('b:projectionist') && !empty('b:projectionist')
        for [root, value] in projectionist#query('simulation')
            return '"' . expand(root . '/' . value) . '"'
        endfor
    endif

    return 'work'
endfunction

" ---------- Mappings ----------
nnoremap <silent> <Plug>TransposeCharacters xp2h :call repeat#set("\<Plug>TransposeCharacters")<CR>
nmap cp <Plug>TransposeCharacters
nnoremap <F8> :Make<CR>
nnoremap <F9> :Dispatch<CR>

" ---------- Mail ----------
" Format Options:
" a Automatic formatting of paragraphs.  Every time text is inserted or
"   deleted the paragraph will be reformatted.
" w Trailing white space indicates a paragraph continues in the next line.
"   A line that ends in a non-white character ends a paragraph.
autocmd FileType mail setlocal formatoptions+=aw

" ---------- Local Configurations ----------
if filereadable(glob($MYVIMRC . ".local"))
    source $MYVIMRC.local
endif

" ---------- ARM Assembly ----------
autocmd BufNewFile,BufRead *.s,*.S set filetype=arm " arm = armv6/7

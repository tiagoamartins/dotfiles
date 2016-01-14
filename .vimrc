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

let mapleader = ","             " Leader is comma

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
    silent !git clone https://github.com/tpope/vim-pathogen $DOTVIM/vendor/pathogen/
endif

if has("vim_starting")
    " Required:
    " Set the runtime path to include Pathogen
    source $DOTVIM/vendor/pathogen/autoload/pathogen.vim
endif

" Required:
" Initialize and pass a path where Pathogen should get plugins
execute pathogen#infect(expand("$DOTVIM/vendor/{}"))
filetype plugin on              " Enable plugins to detect file types

" Make sure Pathogen works with Vim Sessions
set sessionoptions-=options

" ---------- Mouse ----------
set mouse=a                     " Allow mouse use for all modes

" ---------- Backups ----------

" Backup directories
if has("persistent_undo")
    if !isdirectory($DOTVIM . "/temp/undo")
        call mkdir($DOTVIM . "/temp/undo", "p")
    endif
    set undodir=$DOTVIM/temp/undo//
endif
if !isdirectory($DOTVIM . "/temp/backup")
    call mkdir($DOTVIM . "/temp/backup", "p")
endif
set backupdir=$DOTVIM/temp/backup//
if !isdirectory($DOTVIM . "/temp/swap")
    call mkdir($DOTVIM . "/temp/swap", "p")
endif
set directory=$DOTVIM/temp/swap//

set backupskip=/tmp/*,/private/tmp/*"

set backup                      " Keeps a backup after closing the file
set writebackup                 " Creates a backup file after overwriting the file
set noswapfile                  " Swap files are a nuisance

" Persist (g)undo tree between sessions
if has("persistent_undo")
    set undofile
endif
set history=100
set undolevels=100

" ---------- Colors ----------
syntax enable                   " Enable syntax processing
set background=dark             " Set a dark background profile
let g:hybrid_use_Xresources = 1 " Use terminal custom colors
colorscheme hybrid              " Set color scheme

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
set tabstop=4                   " Set tab character visually to a number of spaces characters
set softtabstop=4               " Number of spaces in tab when editing
set shiftwidth=4                " Indent width for autoindent
set expandtab                   " Turn tabs into whitespace
set backspace=indent,eol,start  " Set backspace to be able to delete previous characters
set textwidth=0                 " Width necessary to auto split lines

" Only do this part when compiled with support for autocommands
if has("autocmd")
    " Enable file type detection
    filetype on

    " Syntax of these languages is fussy over tabs Vs spaces
    autocmd FileType make setlocal noexpandtab

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

        let menlo = system("fc-list | grep -c Menlo")
        let consolas = system("fc-list | grep -c Consolas")
        let inconsolata = system("fc-list | grep -c Inconsolata")

        if (menlo > 0)
            set guifont=Menlo\ 10
        elseif (consolas > 0)
            set guifont=Consolas\ 10
        elseif (inconsolata > 0)
            set guifont=Inconsolata\ 10
        else
            set guifont=DejaVu\ Sans\ Mono\ 10
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
set listchars=tab:▸\ ,eol:¬

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
let g:airline_powerline_fonts = 0

let g:airline#extensions#branch#enabled = 1

let g:airline#extensions#tabline#enabled = 1        " Enable the list of buffers
let g:airline#extensions#tabline#fnamemod = ":t"    " Show just the filename
let g:airline#extensions#tabline#tab_nr_type = 2    " Show splits and tab numbers

let g:airline#extensions#whitespace#enabled = 1
let g:airline#extensions#whitespace#mixed_indent_algo = 1

let g:airline#extensions#syntastic#enabled = 1

if !exists("g:airline_symbols")
    let g:airline_symbols = {}
endif

let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#right_sep = ''
let g:airline#extensions#tabline#right_alt_sep = '|'

" unicode symbols
let g:airline_left_sep = ''
let g:airline_right_sep = ''
" let g:airline_left_sep = '▶'
" let g:airline_right_sep = '◀'
let g:airline_left_alt_sep = '»'
let g:airline_right_alt_sep = '«'
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.linenr = '␤'
" let g:airline_symbols.linenr = '␊'
" let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
" let g:airline_symbols.paste = 'Þ'
" let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" ---------- Syntastic ----------
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'
let g:syntastic_style_error_symbol = '✗'
let g:syntastic_style_warning_symbol = '⚠'
let g:syntastic_aggregate_errors = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_vhdl_checkers = ['modelsim']
autocmd BufRead *.vhd let b:syntastic_vhdl_modelsim_args = '-work ' . GetSimulationDir()

" ---------- Gundo ----------
nnoremap <F5> :GundoToggle<CR>
let g:gundo_prefer_python3 = 1

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

" Change snippets default directory
let g:UltiSnipsSnippetsDir = expand("$DOTVIM/after/snips")
let g:UltiSnipsSnippetDirectories = ["snips"]

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
nnoremap <silent> <Plug>TransposeCharacters xp :call repeat#set("\<Plug>TransposeCharacters")<CR>
nmap cp <Plug>TransposeCharacters

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

" Plugins {{{1
" ------------
let plug_file = expand($VIM_HOME . '/autoload/plug.vim')
if empty(glob(plug_file))
    silent execute '!curl -fLo ' . plug_file . ' --create-dirs'
                \ . ' https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif

" Specify a directory for plugins
call plug#begin(expand($VIM_HOME . '/plugged'))

" Colors
Plug 'tiagoamartins/vim-hybrid'

" Editing
Plug 'Vimjas/vim-python-pep8-indent', {'for': ['python']}
Plug 'godlygeek/tabular', {'for': ['systemverilog', 'verilog', 'vhdl']}
Plug 'tpope/vim-apathy'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'

" Plugins
Plug 'aliev/vim-compiler-python'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-projectionist'
Plug 'vim-test/vim-test'

" Syntax
Plug 'ARM9/arm-syntax-vim'
Plug 'Shirk/vim-gas'
Plug 'WeiChungWu/vim-SystemVerilog'
Plug 'tpope/vim-git'
Plug 'vim-python/python-syntax'

if has('nvim')
    " Editing
    Plug 'JoosepAlviste/nvim-ts-context-commentstring'
    Plug 'L3MON4D3/LuaSnip'
    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-treesitter/nvim-treesitter-context'
    Plug 'nvim-treesitter/nvim-treesitter-refactor'
    Plug 'nvim-treesitter/nvim-treesitter-textobjects'
    Plug 'p00f/nvim-ts-rainbow'

    " Completion
    Plug 'f3fora/cmp-spell'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-nvim-lua'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'jc-doyle/cmp-pandoc-references'
    Plug 'quangnguyen30192/cmp-nvim-tags'
    Plug 'ray-x/cmp-treesitter'
    Plug 'saadparwaiz1/cmp_luasnip'

    " Debugging
    Plug 'mfussenegger/nvim-dap'
    Plug 'rcarriga/nvim-dap-ui'
    Plug 'theHamsta/nvim-dap-virtual-text'

    " Interface
    Plug 'lewis6991/gitsigns.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'onsails/lspkind-nvim'
    Plug 'ray-x/lsp_signature.nvim'
endif

call plug#end()

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

if filereadable(glob($MYVIMRC . ".local"))
    source $MYVIMRC.local
endif

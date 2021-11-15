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

" Plugins {{{1
" ------------
let plug_file = expand($VIM_HOME . '/autoload/plug.vim')
if empty(glob(plug_file))
    silent execute '!curl -fLo ' . plug_file . ' --create-dirs'
                \ . ' https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif

" Helper function for conditional plug
function! Cond(cond, ...)
    let opts = get(a:000, 0, {})
    return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

" Specify a directory for plugins
call plug#begin(expand($VIM_HOME . '/plugged'))

" Colors
Plug 'tiagoamartins/vim-hybrid'

" Editing
Plug 'AndrewRadev/switch.vim'
Plug 'JoosepAlviste/nvim-ts-context-commentstring', Cond(has('nvim'))
Plug 'Vimjas/vim-python-pep8-indent', {'for': ['python']}
Plug 'godlygeek/tabular', {'for': ['systemverilog', 'verilog', 'vhdl']}
Plug 'iamcco/markdown-preview.nvim', {'do': { -> mkdp#util#install() },
                                    \ 'for': ['markdown', 'vim-plug']}
Plug 'neovim/nvim-lspconfig', Cond(has('nvim'))
Plug 'nvim-treesitter/nvim-treesitter', Cond(has('nvim'))
Plug 'nvim-treesitter/nvim-treesitter-refactor', Cond(has('nvim'))
Plug 'nvim-treesitter/nvim-treesitter-textobjects', Cond(has('nvim'))
Plug 'p00f/nvim-ts-rainbow', Cond(has('nvim'))
Plug 'romgrk/nvim-treesitter-context', Cond(has('nvim'))
Plug 'tpope/vim-apathy'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'

" Completion
Plug 'f3fora/cmp-spell', Cond(has('nvim'))
Plug 'hrsh7th/cmp-buffer', Cond(has('nvim'))
Plug 'hrsh7th/cmp-nvim-lsp', Cond(has('nvim'))
Plug 'hrsh7th/cmp-nvim-lua', Cond(has('nvim'))
Plug 'hrsh7th/cmp-path', Cond(has('nvim'))
Plug 'hrsh7th/nvim-cmp', Cond(has('nvim'))
Plug 'quangnguyen30192/cmp-nvim-tags', Cond(has('nvim'))

" Interface
Plug 'lewis6991/gitsigns.nvim', Cond(has('nvim'))
Plug 'nvim-lua/plenary.nvim', Cond(has('nvim'))
Plug 'ray-x/lsp_signature.nvim', Cond(has('nvim'))

" Plugins
Plug 'aliev/vim-compiler-python'
Plug 'janko-m/vim-test'
Plug 'machakann/vim-swap'
Plug 'mbbill/undotree'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-projectionist'

" Syntax
Plug 'ARM9/arm-syntax-vim'
Plug 'Shirk/vim-gas'
Plug 'WeiChungWu/vim-SystemVerilog'
Plug 'tpope/vim-git'
Plug 'vim-python/python-syntax'

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

" Change drop-down menu color
highlight PmenuSel ctermfg=black ctermbg=lightgray
" }}}1

if filereadable(glob($MYVIMRC . ".local"))
    source $MYVIMRC.local
endif

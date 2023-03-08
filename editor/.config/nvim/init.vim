" disable python 2 support
let g:loaded_python_provider = 0

" load default python 3
if exists("$VIRTUAL_ENV")
    let g:python3_host_prog=substitute(system("which -a python3 | head -n2 | tail -n1"), "\n", '', 'g')
else
    let g:python3_host_prog=substitute(system("which python3"), "\n", '', 'g')
endif

" disable ruby support
let g:loaded_ruby_provider = 0

" disable node js support
let g:loaded_node_provider = 0

" disable perl support
let g:loaded_perl_provider = 0

" load vim's config
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

if filereadable(glob("~/.vimrc.local"))
    source ~/.vimrc.local
endif

lua require'config/plugins'
lua require'config/mappings'

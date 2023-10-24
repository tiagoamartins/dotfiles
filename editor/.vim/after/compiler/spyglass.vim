if exists("current_compiler")
    finish
endif
let current_compiler = "spyglass"

if exists(":CompilerSet") != 2
    command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

" Error level formats
CompilerSet errorformat =%.%#\ %\\+%tatal\ %\\+%[a-zA-Z0-9]%\\+\ %\\+%f\ %\\+%l\ %\\+%n\ %\\+%m
CompilerSet errorformat+=%.%#\ %\\+%trror\ %\\+%[a-zA-Z0-9]%\\+\ %\\+%f\ %\\+%l\ %\\+%n\ %\\+%m
CompilerSet errorformat+=%.%#\ %\\+Syntax\ %\\+%f\ %\\+%l\ %\\+%m

" Warning level formats
if (!exists("g:verilog_efm_level") || g:verilog_efm_level != "error")
    CompilerSet errorformat+=%.%#\ %\\+%tarning\ %\\+../%f\ %\\+%l\ %\\+%n\ %\\+%m
endif

" Load common errorformat configurations
runtime compiler/verilog.vim

let &cpo = s:cpo_save
unlet s:cpo_save

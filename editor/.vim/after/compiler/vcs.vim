" Vim compiler file
" compiler: Synopsys VCS

if exists("current_compiler")
    finish
endif
let current_compiler = "vcs"

if exists(":CompilerSet") != 2
    command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

" error level formats
CompilerSet errorformat =%EError-\[%.%\\+\]\ %m
CompilerSet errorformat+=%C%m\"%f\"\\,\ %l%.%#
CompilerSet errorformat+=%C%f\\,\ %l
CompilerSet errorformat+=%C%\\s%\\+%l:\ %m\\,\ column\ %c
CompilerSet errorformat+=%C%\\s%\\+%l:\ %m
CompilerSet errorformat+=%C%m\"%f\"\\,%.%#
CompilerSet errorformat+=%Z%p^  " column pointer

CompilerSet errorformat+=%DEntering\ directory\ '%f'
CompilerSet errorformat+=%XLeaving\ directory\ '%f'

CompilerSet errorformat+=%C%m   " catch all rule
CompilerSet errorformat+=%Z     " error message end on empty line

" warning level formats
if (!exists("g:verilog_efm_level") || g:verilog_efm_level != "error")
    CompilerSet errorformat+=%WWarning-\[%.%\\+]\\$
    "Ignore LCA enabled warning
    CompilerSet errorformat+=%-WWarning-[LCA_FEATURES_ENABLED]\ Usage\ warning
    CompilerSet errorformat+=%WWarning-\[%.%\\+\]\ %m
endif

" lint level formats
if (!exists("g:verilog_efm_level") || g:verilog_efm_level == "lint")
    CompilerSet errorformat+=%I%tint-\[%.%\\+\]\ %m
endif

" load common errorformat configurations
runtime compiler/verilog.vim

let &cpo = s:cpo_save
unlet s:cpo_save

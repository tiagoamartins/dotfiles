if exists("current_compiler")
    finish
endif
let current_compiler = "quartus"

if exists(":CompilerSet") != 2
    command -nargs=* CompilerSet setlocal <args>
endif

" Altera Quartus log parser

" Errors:
CompilerSet errorformat=%E%trror\ (%n):\ %m\ File:\ %f\ Line:\ %l
CompilerSet errorformat+=%E%trror\ (%n):\ %m
CompilerSet errorformat+=%C%*\\s%trror\ (%n):\ %m
CompilerSet errorformat+=%E%trror:\ %m
CompilerSet errorformat+=%C%*\\s%trror:\ %m

" Warnings:
CompilerSet errorformat+=%W%tarning\ (%n):\ %.%#\ %f(%l):\ %m
CompilerSet errorformat+=%W%tarning\ (%n):\ %m
CompilerSet errorformat+=%C%*\\s%tarning\ (%n):\ %m

" Infos:
CompilerSet errorformat+=%-G%tnfo\ (%n):\ %m
CompilerSet errorformat+=%-G%*\\s%tnfo\ (%n):\ %m
CompilerSet errorformat+=%-G%tnfo:\ %m
CompilerSet errorformat+=%-G%*\\s%tnfo:\ %m

" Blanks:
CompilerSet errorformat+=%-G\\s%#

" Altera Quartus command lines

" Analyze and Synthesis
" CompilerSet makeprg=quartus_map
" CompilerSet makeprg=quartus_map\ $*\ --analyze_file=\"%:p\"

" Complete compile flow
" CompilerSet makeprg=quartus_sh
CompilerSet makeprg=quartus_sh\ --flow\ compile\ $*

" Programming
" CompilerSet makeprg=quartus_pgm
" CompilerSet makeprg=quartus_pgm\ -z\ -m\ JTAG\ -c\ USB-Blaster[USB-0]\ -o\ \"p;$*\"

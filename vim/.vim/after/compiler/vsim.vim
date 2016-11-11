if exists("current_compiler")
    finish
endif
let current_compiler = "vsim"

if exists(":CompilerSet") != 2 " older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

CompilerSet makeprg=vsim\ -c\ -nostdout\ -quiet\

CompilerSet errorformat=\#\ \*\*\ %trror\ (suppressible):\ %f(%l):\ (vlog-%n)\ %m
CompilerSet errorformat+=\#\ \*\*\ %trror:\ (vsim-%n)\ %f(%l):\ %m
CompilerSet errorformat+=\#\ \*\*\ %trror:\ (vlog-%n)\ %f(%l):\ %m
CompilerSet errorformat+=\#\ \*\*\ %trror:\ %f(%l):\ %m
CompilerSet errorformat+=\#\ \*\*\ %tarning:\ (vsim-%n)\ %f(%l):\ %m
CompilerSet errorformat+=\#\ \*\*\ %tarning:\ (vsim-%n)\ %m
CompilerSet errorformat+=\#\ \*\*\ %tarning:\ %f(%l):\ (vcom-%n)\ %m
CompilerSet errorformat+=\#\ \*\*\ %tarning:\ %f(%l):\ (vlog-%n)\ %m
CompilerSet errorformat+=%E\#\ \*\*\ %trror:\ %m
CompilerSet errorformat+=%E\#\ \*\*\ Fatal:\ (SIGSEGV)\ %m
CompilerSet errorformat+=%I\#\ \*\*\ %tnfo:\ %m
CompilerSet errorformat+=%Z\#%.%#File:\ %f\ Line:\ %l
CompilerSet errorformat+=%I\#\ \*\*\ Note:\ %m:\ %f(%l),%Z%.%#
CompilerSet errorformat+=%-GReading\ %.%#
CompilerSet errorformat+=%-G\#\ %[%^\*]%#
CompilerSet errorformat+=%-G\ %#

let &cpo = s:cpo_save
unlet s:cpo_save

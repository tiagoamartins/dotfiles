if exists("current_compiler")
    finish
endif
let b:current_compiler = "flake8"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
    command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

CompilerSet makeprg=flake8
CompilerSet errorformat=
            \%f:%l:%c:\ %t%*[^0-9]%n\ %m,
            \%f:%l:%c:\ %t%n\ %m,
            \%f:%l:\ %t%n\ %m

let &cpo = s:cpo_save
unlet s:cpo_save

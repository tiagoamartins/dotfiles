if exists("current_compiler")
    finish
endif
let current_compiler = "pytest"

if exists(":CompilerSet") != 2 " older Vim always used :setlocal
    command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

CompilerSet makeprg=pytest\ -o\ addopts=\ --tb=short\ -q

CompilerSet errorformat=
            \%E_%\\+\ %.%#\ _%\\+,
            \%C%f:%l:\ %.%#,
            \%C%[%^E]%.%#,
            \%ZE\ %#%m,

let &cpo = s:cpo_save
unlet s:cpo_save

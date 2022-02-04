if exists("current_compiler")
    finish
endif
let current_compiler = "pytest"

if exists(":CompilerSet") != 2 " older Vim always used :setlocal
    command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

CompilerSet makeprg=pytest\ -o\ addopts=\ --tb=short\ -q\ $*

CompilerSet errorformat=
            \%EE\ %\\{5}File\ \"%f\"\\,\ line\ %l,
            \%CE\ %\\{3}%p^,
            \%ZE\ %\\{3}%[%^\ ]%\\@=%m,
            \%Efile\ %f\\,\ line\ %l,
            \%ZE\ %#%mnot\ found,
            \%E_%\\+\ ERROR\ at\ setup\ of\ %o\ _%\\+,
            \%E_%\\+\ ERROR\ collecting\ %f\ _%\\+,
            \%-G_%\\+\ ERROR%.%#\ _%\\+,
            \%E_%\\+\ %o\ _%\\+,
            \%C%f:%l:\ in\ %o,
            \%EImportError%.%#\'%f\'\.,
            \%C%.%#,
            \%-G%[%^E]%.%#,
            \%-G

let &cpo = s:cpo_save
unlet s:cpo_save

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
            \%Afile\ %f\\,\ line\ %l,
            \%ZE\ %#%mnot\ found,
            \%CE\ %.%#,
            \%-G_%\\+\ ERROR%.%#\ _%\\+,
            \%A_%\\+\ %o\ _%\\+,
            \%C%f:%l:\ in\ %o,
            \%ZE\ %\\{3}%m,
            \%EImportError%.%#\'%f\'\.,
            \%C%.%#,
            \%-G%[%^E]%.%#,
            \%-G

let &cpo = s:cpo_save
unlet s:cpo_save

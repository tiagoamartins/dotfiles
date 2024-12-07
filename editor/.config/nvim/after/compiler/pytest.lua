local set = vim.opt_local

set.makeprg = 'python -m pytest -o addopts= --tb=short -q $*'
set.errorformat = '%EE %\\{5}File \"%f\"\\, line %l,' ..
                  '%CE %\\{3}%p^,' ..
                  '%ZE %\\{3}%[%^ ]%\\@=%m,' ..
                  '%Efile %f\\, line %l,' ..
                  '%ZE %#%mnot found,' ..
                  '%E_%\\+ ERROR at setup of %o _%\\+,' ..
                  '%E_%\\+ ERROR collecting %f _%\\+,' ..
                  '%-G_%\\+ ERROR%.%# _%\\+,' ..
                  '%E_%\\+ %o _%\\+,' ..
                  '%C%f:%l: in %o,' ..
                  '%EImportError%.%#\'%f\'.,' ..
                  '%C%.%#,' ..
                  '%-G%[%^E]%.%#,' ..
                  '%-G'

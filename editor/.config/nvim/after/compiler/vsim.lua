local set = vim.opt_local

set.makeprg = 'vsim -c -nostdout -quiet'

set.errorformat = '# ** %trror (suppressible): %f(%l): (vlog-%n) %m' ..
                  '# ** %trror: (vsim-%n) %f(%l): %m' ..
                  '# ** %trror: (vlog-%n) %f(%l): %m' ..
                  '# ** %trror: %f(%l): %m' ..
                  '# ** %tarning: (vsim-%n) %f(%l): %m' ..
                  '# ** %tarning: (vsim-%n) %m' ..
                  '# ** %tarning: %f(%l): (vcom-%n) %m' ..
                  '# ** %tarning: %f(%l): (vlog-%n) %m' ..
                  '%E# ** %trror: %m' ..
                  '%E# ** Fatal: (SIGSEGV) %m' ..
                  '%I# ** %tnfo: %m' ..
                  '%Z#%.%#File: %f Line: %l' ..
                  '%I# ** Note: %m: %f(%l),%Z%.%#' ..
                  '%-GReading %.%#' ..
                  '%-G# %[%^*]%#' ..
                  '%-G %#'

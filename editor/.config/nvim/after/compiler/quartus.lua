local set = vim.opt_local

set.makeprg = 'quartus_sh --flow compile $*'
set.errorformat = '%E%trror (%n): %m File: %f Line: %l' ..
                  '%E%trror (%n): %m' ..
                  '%C%*\\s%trror (%n): %m' ..
                  '%E%trror: %m' ..
                  '%C%*\\s%trror: %m' ..
                  '%W%tarning (%n): %.%# %f(%l): %m' ..
                  '%W%tarning (%n): %m' ..
                  '%C%*\\s%tarning (%n): %m' ..
                  '%-G%tnfo (%n): %m' ..
                  '%-G%*\\s%tnfo (%n): %m' ..
                  '%-G%tnfo: %m' ..
                  '%-G%*\\s%tnfo: %m' ..
                  '%-G\\s%#'

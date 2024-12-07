local set = vim.opt_local

set.errorformat = '%.%# %\\+%tatal %\\+%[a-zA-Z0-9]%\\+ %\\+%f %\\+%l %\\+%n %\\+%m' ..
                  '%.%# %\\+%trror %\\+%[a-zA-Z0-9]%\\+ %\\+%f %\\+%l %\\+%n %\\+%m' ..
                  '%.%# %\\+Syntax %\\+%f %\\+%l %\\+%m' ..
                  '%.%# %\\+%tarning %\\+../%f %\\+%l %\\+%n %\\+%m'

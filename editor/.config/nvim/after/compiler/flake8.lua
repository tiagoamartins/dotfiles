local set = vim.opt_local

set.makeprg = 'flake8'
set.errorformat = '%f:%l:%c: %t%*[^0-9]%n %m,' ..
                  '%f:%l:%c: %t%n %m,' ..
                  '%f:%l: %t%n %m'

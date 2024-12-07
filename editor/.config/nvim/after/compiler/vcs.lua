local set = vim.opt_local

set.errorformat = '%EError-[%.%\\+] %m' ..
                  '%C%m"%f"\\, %l%.%#' ..
                  '%C%f\\, %l' ..
                  '%C%\\s%\\+%l: %m\\, column %c' ..
                  '%C%\\s%\\+%l: %m' ..
                  '%C%m"%f"\\,%.%#' ..
                  '%Z%p^  " column pointer' ..
                  '%DEntering directory '%f'' ..
                  '%XLeaving directory '%f'' ..
                  '%C%m   " catch all rule' ..
                  '%Z     " error message end on empty line' ..
                  '%WWarning-[%.%\\+]\\$' ..
                  '%-WWarning-[LCA_FEATURES_ENABLED] Usage warning' ..
                  '%WWarning-[%.%\\+] %m' ..
                  '%I%tint-[%.%\\+] %m'

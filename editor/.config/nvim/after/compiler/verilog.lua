local set = vim.opt_local

set.errorformat = 'UVM_%tNFO %f(%l) %m' ..
                  'UVM_%tARNING %f(%l) %m' ..
                  'UVM_%tRROR %f(%l) %m' ..
                  'UVM_%tATAL %f(%l) %m'

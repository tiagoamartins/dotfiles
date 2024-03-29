if exists(":CompilerSet") != 2
    command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

" append UVM errorformat if enabled
if (exists("g:verilog_efm_uvm_lst"))
    let verilog_efm_uvm = utils#get_var('verilog_efm_uvm_lst')
    if (index(verilog_efm_uvm, 'all') >= 0 || index(verilog_efm_uvm, 'info') >= 0)
        CompilerSet errorformat+=UVM_%tNFO\ %f(%l)\ %m
    endif
    if (index(verilog_efm_uvm, 'all') >= 0 || index(verilog_efm_uvm, 'warning') >= 0)
        CompilerSet errorformat+=UVM_%tARNING\ %f(%l)\ %m
    endif
    if (index(verilog_efm_uvm, 'all') >= 0 || index(verilog_efm_uvm, 'error') >= 0)
        CompilerSet errorformat+=UVM_%tRROR\ %f(%l)\ %m
    endif
    if (index(verilog_efm_uvm, 'all') >= 0 || index(verilog_efm_uvm, 'fatal') >= 0)
        CompilerSet errorformat+=UVM_%tATAL\ %f(%l)\ %m
    endif
endif

" append any user-defined efm entries
if (exists("g:verilog_efm_custom"))
    CompilerSet errorformat+=g:verilog_efm_custom
endif

" cleanup rule
if (exists("g:verilog_efm_quickfix_clean"))
    CompilerSet errorformat+=%-G%.%#
endif

let &cpo = s:cpo_save
unlet s:cpo_save
